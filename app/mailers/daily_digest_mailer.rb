class DailyDigestMailer < ApplicationMailer
  def digest(user, questions)
    @questions = questions

    mail to: user.email, subject: 'Daily Digest from QnA!'
  end
end
