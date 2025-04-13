# frozen_string_literal: true
require_dependency 'barong/middleware/jwt_authenticator'
require_relative 'users'
require_relative 'documents'
require_relative 'api_keys'
require_relative 'activities'
require_relative 'permissions'
require_relative 'levels'
require_relative 'metrics'
require_relative 'restrictions'
require_relative 'abilities'
require_relative 'attachments'
require_relative 'profiles'
require_relative 'entities/user_with_kyc'
require_relative 'entities/user_with_profile'
require_relative '../entities/api_key'


module API::V2
  module Admin
    class Base < Grape::API
      PREFIX = '/admin'

      use Barong::Middleware::JwtAuthenticator, \
            pubkey: Rails.configuration.x.keystore.public_key

      cascade false

      format         :json
      content_type   :json, 'application/json'
      default_format :json

      helpers API::V2::Resource::Utils

      do_not_route_options!

      mount Admin::Users
      mount Admin::Documents
      mount Admin::APIKeys
      mount Admin::Permissions
      mount Admin::Activities
      mount Admin::Metrics
      mount Admin::Restrictions
      mount Admin::Profiles
      mount Admin::Levels
      mount Admin::Abilities
      mount Admin::Attachments

      add_swagger_documentation base_path: File.join(API.try(:Base).try(:PREFIX) || '/api',
                                                     API.try(:V2).try(:Base).try(:API_VERSION) || 'v2',
                                                    'barong',
                                                     PREFIX),
                                add_base_path: true,
                                mount_path:  '/swagger',
                                api_version: API.try(:V2).try(:Base).try(:API_VERSION) || 'v2',
                                doc_version: Barong::Application::GIT_TAG,
                                info: {
                                  title: 'Barong',
                                  description: 'RESTful AdminAPI for barong OAuth server'
                                },
                                security_definitions: {
                                  'BearerToken': {
                                    description: 'Bearer Token authentication',
                                    type: 'basic',
                                    name: 'Authorization',
                                    in: 'header'
                                  }
                                },
                                models: [
                                  API::V2::Admin::Entities::ActivityWithUser,
                                  API::V2::Admin::Entities::AdminActivity,
                                  API::V2::Admin::Entities::Document,
                                  API::V2::Admin::Entities::Phone,
                                  API::V2::Admin::Entities::Profile,
                                  API::V2::Admin::Entities::UserWithKyc,
                                  API::V2::Admin::Entities::UserWithProfile,
                                  API::V2::Entities::APIKey
                                ]
    end
  end
end
