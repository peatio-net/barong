# frozen_string_literal: true

module API::V2
  module Resource
    class Phones < Grape::API
      rescue_from(Twilio::REST::RestError) do |error|
        Rails.logger.error "Twilio Client Error: #{error.message}"
        error!({ errors: [twilio_dictionary_error(error.code)] }, 422)
      end

      helpers do
        def validate_phone!(phone_number)
          phone_number = Phone.international(phone_number)
          Rails.logger.warn "validate_phone : #{phone_number}"
          error!({ errors: ['resource.phone.invalid_num'] }, 400) \
            unless Phone.valid?(phone_number)

          error!({ errors: ['resource.phone.number_exist'] }, 400) \
            if Phone.verified.find_by_number(phone_number)
        end
      end

      desc 'Phone related routes'
      resource :phones do
        desc 'Returns list of user\'s phones',
          failure: [
            { code: 401, message: 'Invalid bearer token' },
          ],
          success: Entities::Phone
        get do
          present current_user.phones, with: Entities::Phone
        end

        desc 'Add new phone',
          failure: [
            { code: 400, message: 'Required params are empty' },
            { code: 401, message: 'Invalid bearer token' },
            { code: 404, message: 'Record is not found' },
            { code: 422, message: 'Validation errors' }
          ],
          success: { code: 200, message: 'New phone was added' }
        params do
          requires :phone_number,
                   type: String,
                   allow_blank: false,
                   desc: 'Phone number with country code'
          optional :channel,
                   type: String,
                   default: 'sms',
                   values: { value: -> { Phone::TWILIO_CHANNELS }, message: 'resource.phone.invalid_channel'},
                   desc: 'The verification method to use'
        end
        post do
          declared_params = declared(params)
          validate_phone!(declared_params[:phone_number])

          phone_number = Phone.international(declared_params[:phone_number])
          error!({ errors: ['resource.phone.exists'] }, 400) if current_user.phones.find_by_number(phone_number)

          if current_user.phones.unverified.count >= Barong::App.config.phone_max_unverified
            current_user.update(state: 'banned')
            error!({ errors: ['resource.phone.too_many_unverified'] }, 400)
          end
          phone_number = Phone.sanitize(phone_number)
          phone = current_user.phones.create(number: phone_number)
          code_error!(phone.errors.details, 422) if phone.errors.any?

          Barong::App.config.twilio_provider.send_confirmation(phone, declared_params[:channel])
          { message: "Code was sent successfully via #{declared_params[:channel]}" }
        end

        desc 'Resend activation code',
          failure: [
            { code: 400, message: 'Required params are empty' },
            { code: 401, message: 'Invalid bearer token' },
            { code: 404, message: 'Record is not found' },
            { code: 422, message: 'Validation errors' }
          ],
          success: { code: 200, message: 'Activation code was resend' }
        params do
          requires :phone_number,
                   type: String,
                   allow_blank: false,
                   desc: 'Phone number with country code'
          optional :channel,
                   type: String,
                   default: 'sms',
                   values: { value: -> { Phone::TWILIO_CHANNELS }, message: 'resource.phone.invalid_channel'},
                   desc: 'The verification method to use'
        end
        post '/send_code' do
          declared_params = declared(params)
          validate_phone!(declared_params[:phone_number])

          Rails.logger.warn "send_code declared_params: #{declared_params}"

          phone_number = Phone.international(declared_params[:phone_number])
          phone = current_user.phones.find_by_number(phone_number)

          Rails.logger.warn "send_code phone_number: #{phone_number}"

          error!({ errors: ['resource.phone.doesnt_exist'] }, 404) unless phone

          if Time.now - phone.updated_at < Barong::App.config.phone_code_min_delay.seconds
            error!({ errors: ['resource.phone.code_sent_too_fast'] }, 400)
          end

          if phone.retries_send >= Barong::App.config.phone_max_send_retries
            error!({ errors: ['resource.phone.too_many_retries'] }, 400)
          end

          Barong::App.config.twilio_provider.send_confirmation(phone, declared_params[:channel])

          phone.increment!(:retries_send)
          { message: "Code was sent successfully via #{declared_params[:channel]}" }
        end

        desc 'Verify a phone',
          failure: [
            { code: 400, message: 'Required params are empty' },
            { code: 401, message: 'Invalid bearer token' },
            { code: 404, message: 'Record is not found' }
          ],
          success: API::V2::Entities::UserWithFullInfo
        params do
          requires :phone_number,
                   type: String,
                   allow_blank: false,
                   desc: 'Phone number with country code'
          requires :verification_code,
                   type: String,
                   allow_blank: false,
                   desc: 'Verification code from sms'
        end
        post '/verify' do
          declared_params = declared(params)
          validate_phone!(declared_params[:phone_number])
          Rails.logger.warn "verify declared_params: #{declared_params}"

          phone_number = Phone.international(declared_params[:phone_number])
          Rails.logger.warn "verify phone_number: #{phone_number}"
          phone = current_user.phones.find_by_number(phone_number)
          error!({ errors: ['resource.phone.doesnt_exist'] }, 404) unless phone

          verification = Barong::App.config.twilio_provider.verify_code?(number: phone_number, code: declared_params[:verification_code], user: current_user)
          unless verification
            phone.increment!(:retries_verify)
            if phone.retries_verify >= Barong::App.config.phone_max_verify_retries
              current_user.update(state: 'banned')
              error!({ errors: ['resource.phone.too_many_retries'] }, 400)
            end
            error!({ errors: ['resource.phone.verification_invalid'] }, 404)
          end

          phone.update(validated_at: Time.current)
          current_user.labels.create(key: 'phone', value: 'verified', scope: 'private')

          present current_user, with: API::V2::Entities::UserWithFullInfo
        end
      end
    end
  end
end
