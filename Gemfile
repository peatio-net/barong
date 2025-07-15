# Gemfile - Phase 1: Rails 6.0
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.3.5'

# Core Rails 6.0 - Intermediate step
gem 'rails', '~> 6.0.6'
gem 'puma', '~> 4.3'
gem 'bootsnap', '>= 1.4.4', require: false

# Database
gem 'mysql2', '~> 0.5.3'
gem 'pg', '~> 1.2'

# Redis and background jobs
gem 'redis', '~> 4.8'
gem 'hiredis', '~> 0.6.1'
gem 'sidekiq', '~> 6.5'

# API framework
gem 'grape', '~> 1.6'
gem 'grape-entity', '~> 0.10'
gem 'grape-swagger', '~> 1.4'
gem 'grape-swagger-entity', '~> 0.5'
gem 'grape_logging', '~> 1.8'
gem 'api-pagination', '~> 4.8.2'

# Authentication and security
gem 'bcrypt', '~> 3.1.16'
gem 'jwt', '~> 2.5'
gem 'jwt-multisig', '~> 1.0', '>= 1.0.4'
gem 'cancancan', '~> 3.3'

# Validation and verification
gem 'email_validator', '~> 2.0'
gem 'recaptcha', '~> 5.8'
gem 'strong_password', '~> 0.0.9'
gem 'phonelib', '~> 0.10.3'

# Cloud storage
gem 'carrierwave', '~> 2.2'
gem 'fog-core', '~> 2.1'
gem 'fog-aliyun', '~> 0.3.5'
gem 'fog-aws', '~> 3.24'
gem 'fog-google', '~> 1.20'

# External services
gem 'aliyun-sdk', '~> 0.7.0'
gem 'twilio-ruby', '~> 5.60'
gem 'kycaid'
gem 'vault', '~> 0.16'
gem 'vault-rails', git: 'https://github.com/rubykube/vault-rails'

# Messaging
gem 'bunny', '~> 2.19'

# Cryptography
gem 'base58', '~> 0.2.3'
gem 'blake2b', '~> 0.10.0'
gem 'ed25519', '~> 1.2.4'

# Utilities
gem 'env-tweaks', '~> 1.0.0'
gem 'kaminari', '~> 1.2'
gem 'peatio', '~> 0.4.4'
gem 'rack-cors', '~> 1.1'
gem 'rack-attack', '~> 6.5'
gem 'memoist', '~> 0.16'
gem 'maxmind-db', '~> 1.1'
gem 'countries', '~> 4.0', require: 'countries/global'
gem 'browser', '~> 5.0', require: "browser/browser"
gem 'bump', '~> 0.10'

# Asset pipeline
gem 'uglifier', '~> 4.2'
gem 'mini_racer', '~> 0.6', platforms: :ruby

# Monitoring and logging
gem 'sentry-ruby', '~> 5.5'
gem 'sentry-rails', '~> 5.5'

# Development tools
gem 'pry-rails', '~> 0.3'

group :development, :test do
  gem 'pry-byebug', '~> 3.9', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails', '~> 6.1'
  gem 'faker', '~> 2.19'
  gem 'rspec-rails', '~> 5.0'
end

group :development do
  gem 'grape_on_rails_routes', '~> 0.3.2'
  gem 'web-console', '~> 4.1'
  gem 'listen', '~> 3.7'
  gem 'annotate', '~> 3.1'
end

group :test do
  gem 'capybara', '~> 3.36'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'rails-controller-testing', '~> 1.0.5'
  gem 'database_cleaner-active_record', '~> 2.0'
end

