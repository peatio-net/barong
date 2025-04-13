source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.3.0'

gem 'aliyun-sdk',  '~> 0.7.0'
gem 'api-pagination', '~> 6.0'
gem 'base58', '~> 0.2.3'
gem 'blake2b', '~> 0.10.0'
gem 'ed25519', '~> 1.2.4'

# storage related gems
gem 'carrierwave', '~> 3.1', '>= 3.1.1'
# fog's core, shared behaviors without API and provider specifics
gem 'fog-core', '~> 2.1.0'
# alicloud support
gem 'fog-aliyun', '~> 0.3.5'
# aws support (amazon)
gem 'fog-aws', '~> 3.24.0'
# gcp support (google)
gem 'fog-google', '~> 1.20.0'
gem 'kycaid'
gem 'sidekiq', '>= 6.0.7'
# GLI
gem 'gli', '~> 2.22', '>= 2.22.2'
##
## abilities and permissions for admin API module
gem 'cancancan', '~> 3.6', '>= 3.6.1'

gem 'hiredis', '~> 0.6.1'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.1.0'
# gem 'rails', '~> 5.2.4', '>= 5.2.4.4'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
# Use Puma as the app server
gem 'puma', '~> 4.3.8'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'mini_racer', platforms: :ruby

gem 'maxmind-db', '~> 1.0'

gem 'kaminari', '>= 1.2.1'
gem 'peatio', '~> 3.1', '>= 3.1.1'
gem 'rack-cors', '~> 1.0.2'
gem 'rack-attack', '>= 6.7.0'

# REST-like API framework for Ruby
gem 'grape', '~> 2.3'
gem 'grape-entity', '~> 1.0', '>= 1.0.1'
gem 'grape-swagger', '~> 2.1', '>= 2.1.2'
gem 'grape-swagger-entity', '~> 0.5'
gem 'grape_logging', '~> 1.8'
gem 'memoist', '~> 0.16'
gem 'jwt', '~> 2.2'
gem 'jwt-multisig', '~> 1.0', '>= 1.0.4'
gem 'bunny'
gem 'phonelib',     '~> 0.10.3'
gem 'twilio-ruby', '>= 5.31.2'
gem 'vault',        '~> 0.1'
gem 'vault-rails', git: 'https://github.com/rubykube/vault-rails'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0', :require => ['redis', 'redis/connection/hiredis']

gem 'bcrypt', '~> 3.1'
# Email validators. Lock at 1.6.0 to use /strict dependency
gem 'email_validator', '= 1.6.0', require: 'email_validator/strict'

gem 'countries', require: 'countries/global'
gem 'browser', require: "browser/browser"
gem 'bump'

# Use gem to verify recatpcha on server side
gem 'recaptcha', '>= 5.2.1'
# Password validators
gem 'strong_password', '~> 0.0.8'
# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Add the Sentry Ruby SDK
gem 'sentry-ruby', '~> 5.14'
gem 'pry-rails'
gem 'validates_email_format_of', '~> 1.8', '>= 1.8.2'

group :development, :test do
  # Call 'byebug' or 'binding.pry' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails', '~> 6.2.0'
  gem 'faker',              '~> 2.1'
  gem 'byebug'
end

group :development do
  gem 'grape_on_rails_routes', '~> 0.3.2'
  gem 'web-console', '>= 3.7.0'
  gem 'listen',       '>= 3.0.5', '< 3.2'
  gem 'annotate', '~> 3.2'
end

group :test do
  gem 'capybara', '>= 3.29.0'
  # gem 'selenium-webdriver'
  # gem 'chromedriver-helper'
  gem 'rspec-rails', '~> 7.1', '>= 7.1.1'
  gem 'shoulda-matchers', '~> 6.4'
  gem 'rails-controller-testing', '>= 1.0.5'
  gem 'database_cleaner', '~> 2.0.1'
end

gem "pg", "~> 1.2"
