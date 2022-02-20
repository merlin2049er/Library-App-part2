class DailycheckoutreminderMailerJob < ApplicationJob
  queue_as :default

  def perform
    # Do something later
    puts "hare we are "
    User.all.each do |user|
      ReminderMailer.reminder_email(user).deliver_now
    end
  end
end
