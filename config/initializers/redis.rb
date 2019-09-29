# frozen_string_literal: true

require 'sidekiq/scheduler'

redis_params = {
  host: Settings.redis.host,
  port: Settings.redis.port,
  password: Settings.redis.password,
  id: nil
}

$redis = Redis::Namespace.new(
  Settings.redis.namespace,
  redis: Redis.new(redis_params.merge(db: Settings.redis.queue))
)

# Redis::Object
Redis.current = Redis::Namespace.new(
  Settings.redis.namespace,
  redis: Redis.new(redis_params.merge(db: Settings.redis.object_db))
)

Sidekiq.configure_server do |config|
  config.redis = redis_params.merge(db: Settings.redis.sidekiq_db)
end

Sidekiq.configure_client do |config|
  config.redis = redis_params.merge(db: Settings.redis.sidekiq_db)
end

Sidekiq.configure_server do |config|
  config.on(:startup) do
    Sidekiq.schedule = YAML.load_file(File.expand_path('../scheduler.yml', __dir__))
    Sidekiq::Scheduler.reload_schedule!
  end
end
