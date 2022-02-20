require 'sidekiq-cron'

class HardJob
  include Sidekiq::Job

  def perform(*args)
    # Do something
  
    DailycheckoutreminderMailerJob.perform_now
  end

end
# Sidekiq::Cron::Job.destroy_all!

# Sidekiq::Cron::Job.all.delete_all
# Sidekiq::Cron::Job.create(name: 'Hard worker - every 5min', cron: '*/1 * * * *', class: 'HardJob') # execute at every 5 minutes, ex: 12:05, 12:10, 12:15...etc
