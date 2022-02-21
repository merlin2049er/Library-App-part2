class ReminderMailer < ApplicationMailer

  default from: "jguerra@jginfosys.com"
  layout 'mailer'


  def reminder_email(user)
    @user = user
    mail(to: @user.email, subject: 'Youe books on hold arrived...')

  end


end
