# frozen_string_literal: true

module API::V2
  module Entities
    class UserWithProfile < API::V2::Entities::Base
      expose :email,
             documentation: {
              type: 'String',
              desc: 'User Email'
             }

      expose :uid,
             documentation: {
              type: 'String',
              desc: 'User UID'
             }

      expose :role,
             documentation: {
              type: 'String',
              desc: 'User role'
             }

      expose :level,
             documentation: {
              type: 'Integer',
              desc: 'User level'
             }

      expose :otp,
             documentation: {
              type: 'Boolean',
              desc: 'is 2FA enabled for account'
             }

      expose :state,
             documentation: {
              type: 'String',
              desc: 'User state: active, pending, inactive'
             }

      expose :referral_uid,
             documentation: {
              type: 'String',
              desc: 'UID of referrer'
             } do |user|
                user.referral_uid
             end

      expose :data,
             documentation: {
              type: 'String',
              desc: 'Additional phone and profile info'
             }

      expose :profiles, using: Entities::Profile

      with_options(format_with: :iso_timestamp) do
        expose :created_at
        expose :updated_at
      end
    end
  end
end
