# frozen_string_literal: true
# require_relative 'utils'
# require_relative 'general'
# require_relative 'users'
# require_relative 'sessions'


module API
  module V2
    module Identity
      # base api configurations for module
      class Base < Grape::API
        helpers API::V2::Identity::Utils

        do_not_route_options!

        mount Identity::General
        mount Identity::Sessions
        mount Identity::Users
      end
    end
  end
end
