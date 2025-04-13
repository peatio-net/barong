# frozen_string_literal: true

require_relative 'boot'
require 'rails/all'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Barong
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1
    # config.load_defaults 6.0
    # config.active_support.cache_format_version = 7.1
    # config.add_autoload_paths_to_load_path = false

    # Configure Sentry as early as possible.
    if ENV["BARONG_SENTRY_DSN_BACKEND"].present?
      Sentry.init do |config|
        config.dsn = ENV["BARONG_SENTRY_DSN_BACKEND"]
      end
    end
    
    # Rails.autoloaders.log!
    # Setup the logger
    config.logger = Logger.new(STDOUT)

    config.eager_load_paths += Dir[Rails.root.join('app')]
    config.eager_load_paths += Dir[Rails.root.join('lib')]

    # Load lib folder files to be visible in specs
    # config.paths.add 'lib', eager_load: false, autoload: true
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    def env_true?(key)
      !env_false?(key)
    end

    def env_false?(key)
      value = ENV[key]&.downcase
      value.blank? || %w[false 0 nil null].include?(value)
    end
  end
end
