require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let!(:user) { create(:user) }
    let!(:questions) { create_list(:question, 3) }
    let!(:mail) { DailyDigestMailer.digest(user, questions) }

    it "renders the headers" do
      expect(mail.subject).to eq 'Daily Digest from QnA!'
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq ['qna@mail.com']
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("New questions in QnA:")
    end
  end
end
