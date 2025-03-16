# frozen_string_literal: true

require_relative 'boot'
require 'rails/all'
require 'carrierwave'
require 'memoist'
require 'phonelib'
require 'rack/attack'
require 'active_model/railtie'
require 'active_job/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.

module Barong
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Configure Sentry as early as possible.
    if ENV["BARONG_SENTRY_DSN_BACKEND"].present?
      require "sentry-raven"
      Raven.configure { |config| config.dsn = ENV["BARONG_SENTRY_DSN_BACKEND"] }
    end

    config.before_initialize do
      database_config_file = Rails.root.join('config', 'database.yml')
      if File.exist?(database_config_file)
        raw_config = File.read(database_config_file)
        YAML_CONFIG = Psych.safe_load(raw_config, aliases: true)
        Rails.application.config.database_configuration = YAML_CONFIG
      end
    end

    # Adding Grape API
    # Eager loading all app/ folder
    # config.autoload_paths << Rails.root.join('barong', 'lib', 'barong')
    config.autoload_paths += %W[
      #{config.root}/lib
      #{config.root}/lib/barong
      #{config.root}/app
      #{config.root}/app/api
      #{config.root}/app/api/v2
    ]

    config.eager_load_paths += %W[
      #{config.root}/lib
      #{config.root}/lib/barong
    ]

    # Setup the logger
    config.logger = Logger.new(STDOUT)

    # Load lib folder files to be visible in specs
    # config.paths.add 'lib', eager_load: false, autoload: true
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
