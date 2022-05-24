class NotificationService
  def send_notify(question)
    mailings = question.mailings

    if mailings.present?
      mailings.each do |mailing|
        NotificationMailer.notify(mailing.user, question).deliver_later
      end
    end
  end
end
