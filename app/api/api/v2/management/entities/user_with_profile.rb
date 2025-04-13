# frozen_string_literal: true
require_relative '../../entities/user_with_profile'
module API::V2::Management
  module Entities
    class UserWithProfile < API::V2::Entities::UserWithProfile
      expose :profiles, using: Entities::Profile
    end
  end
end
