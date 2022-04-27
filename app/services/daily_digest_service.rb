class DailyDigestService
  def send_digest
    questions = Question.yesterday_questions.to_a

    if questions.present?
      User.find_each(batch_size: 500) do |user|
        DailyDigestMailer.digest(user, questions).deliver_later
      end
    end
  end
end
