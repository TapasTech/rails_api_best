# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'hiredis'
gem 'redis', '~> 4.0'
gem 'redis-namespace'
gem 'redis-objects'

# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'sidekiq'
gem 'sidekiq-scheduler'

gem 'rest-client'

gem 'kaminari'

gem 'config'

gem 'aasm'

gem 'oj'

gem 'rails_param'

gem 'rack-cors'

gem 'awesome_print'
gem 'pry-rails'

gem 'exception_notification'

gem 'lograge'
gem 'logstash-event'
gem 'logstash-logger'

gem 'rolify'

gem 'rubocop-rails'

gem 'rswag-api'
gem 'rswag-ui'

group :development, :test do
  gem 'byebug'

  gem 'rspec-rails'
  gem 'rswag-specs'

  gem 'airborne'

  gem 'factory_bot_rails'
  gem 'ffaker'
end

group :development do
  gem 'annotate'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
