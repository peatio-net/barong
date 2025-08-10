require 'sidekiq'
module KYC
  module Kycaid
    class ReminderWorker
      include Sidekiq::Worker
      KYC_STEPS = [
        { key: 'email_verification', valid_value: 'verified', name: 'Email Verification',
          description: 'Please verify your email address by clicking the link sent to your inbox.' },
        { key: 'phone_verification', valid_value: 'verified', name: 'Phone Verification',
          description: 'Please verify your phone number by entering the OTP sent to your phone.' },
        { key: 'personal_details', valid_value: 'submitted', name: 'Personal Details',
          description: 'Please provide your personal information, including full name and date of birth.' },
        { key: 'document_verification', valid_value: 'verified', name: 'Identity Document',
          description: 'Please upload a valid identity document (e.g., passport or ID card).' },
        { key: 'address_verification', valid_value: 'verified', name: 'Address Verification',
          description: 'Please upload a document verifying your address (e.g., utility bill or bank statement).' }
      ]

      def perform
        users = User.where(:level.lt => 3).to_a

        users.each do |user|
          next unless user.email.present?
          next if user.level.to_i >= 3

          labels = user.labels.where(scope: 'public').pluck(:key, :value).to_h

          statuses = KYC_STEPS.map do |step|
            labels[step[:key]] == step[:valid_value] ? '✓' : '✗'
          end

          completed_steps = statuses.count('✓')

          next if completed_steps == 5

          next_step_index = statuses.index('✗') || 0
          next_step = KYC_STEPS[next_step_index][:name]
          next_step_description = KYC_STEPS[next_step_index][:description]

          begin
            params[:user] = user
            params[:record] =
              { completed_steps: completed_steps, statuses: statuses, next_step: next_step,
                next_step_description: next_step_description }
            params[:subject] = 'Complete Your KYC Verification'
            params[:template_name] = 'coinport-kyc-reminder-email.html.erb'

            Postmaster.process_payload(params).deliver_now
            Rails.logger.info "Sent KYC reminder email to user #{user.uid} (#{completed_steps}/5 steps completed, Next Step: #{next_step})"
          rescue StandardError => e
            Rails.logger.error "Failed to send KYC reminder email to user #{user.uid}: #{e.message}"
          end
        end
      end
    end
  end
end
