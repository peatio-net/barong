# frozen_string_literal: true
require_relative '../../entities/user_with_kyc'
require_relative 'profile'
require_relative 'phone'
require_relative 'document'

module API::V2::Management
  module Entities
    class UserWithKyc < API::V2::Entities::UserWithKyc
      expose :profiles, using: Entities::Profile
      expose :phones, using: Entities::Phone
      expose :documents, using: Entities::Document
    end
  end
end
