# frozen_string_literal: true

class Postmaster < ApplicationMailer
  layout 'mailer'

  def process_payload(params)
    @record  = params[:record]
    @changes = params[:changes]
    @user    = params[:user]
    @logo    = params[:logo]

    sender = "#{Barong::App.config.sender_name} <#{Barong::App.config.sender_email}>"
    Rails.logger.info { "record: #{@record} \n  changes: #{@changes}" }


    if @record.include?(:internal_transfer_sender) && @record.include?(:internal_transfer_receiver)
      [@record[:internal_transfer_sender], @record[:internal_transfer_receiver]].each do |email|
        email_options = {
          subject: params[:subject],
          template_name: params[:template_name],
          from: sender,
          to: email
        }

        mail(email_options)
      end
    else
      email_options = {
        subject: params[:subject],
        template_name: params[:template_name],
        from: sender,
        to: @user.email
      }

      mail(email_options)
    end
  end
end
