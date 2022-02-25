class ReminderMailer < ApplicationMailer

  default from: "jguerra@jginfosys.com"
  layout 'mailer'


  def reminder_email(book)

    book.notify_users.each do |i|
      @user = i
      mail(to: @user.email, subject: 'Your book on hold has arrived...')
    end

  end

end
