# Preview all emails at http://localhost:3000/rails/mailers/notification
class NotificationPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notification/notify
  def notify
    NotificationMailer.notify(User.first, Question.first)
  end

end
