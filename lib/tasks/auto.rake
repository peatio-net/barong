namespace :auto do
  desc 'run task auto'

  task reminder_kyc: :environment do
   KYC::Kycaid::ReminderWorker.perform_async
  end
end