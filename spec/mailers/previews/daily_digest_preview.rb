# Preview all emails at http://localhost:3000/rails/mailers/daily_digest
class DailyDigestPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/daily_digest/digest
  def digest
    DailyDigestMailer.digest(User.first, Question.limit(3))
  end

end
