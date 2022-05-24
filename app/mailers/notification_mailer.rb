class NotificationMailer < ApplicationMailer
  def notify(user, question)
    @question = question

    mail to: user.email, subject: 'New answer to question!'
  end
end
