# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsapiBestServer
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.time_zone = 'Asia/Shanghai'

    config.eager_load_paths += Dir[Rails.root.join('services')]
    config.eager_load_paths += Dir[Rails.root.join('lib')]

    # cache_store
    config.cache_store = :redis_cache_store, {
      host: Settings.redis.host,
      password: Settings.redis.password,
      port: Settings.redis.port,
      db: Settings.redis.cache,
      expires_in: Settings.redis.expires_in,
      namespace: Settings.redis.namespace
    }

    # active_job
    config.active_job.queue_adapter = :sidekiq
    config.active_job.queue_name_prefix = Rails.env
    config.active_job.queue_name_delimiter = '_'

    # action_mailer
    config.action_mailer.perform_caching = false
    config.action_mailer.raise_delivery_errors = false
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: Settings.mailer.address,
      port: Settings.mailer.port,
      domain: Settings.mailer.domain,
      user_name: Settings.mailer.user_name,
      password: Settings.mailer.password,
      authentication: Settings.mailer.authentication,
      ssl: Settings.mailer.ssl
    }

    # rspec
    config.generators do |g|
      g.helper false
      g.assets false
      g.view_specs false
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false
      g.factory_bot dir: 'spec/factories'
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.action_controller.default_protect_from_forgery = false
  end
end
