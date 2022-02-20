# config/initializers/sidekiq.rb

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'], size: 4, network_timeout: 5 }
end

Sidekiq.configure_server do |config|

  config.redis = { url: ENV['REDIS_URL'], size: 4, network_timeout: 5 }
end
Sidekiq::Cron::Job.destroy_all!
# # if File.exist?(schedule_file) && Sidekiq.server
Sidekiq::Cron::Job.create(name: 'Hard worker - every 5min', cron: '*/1 * * * *', class: 'HardJob') # execute at every 5 minutes, ex: 12:05, 12:10, 12:15...etc
# end
