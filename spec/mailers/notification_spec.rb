require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "notify" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let(:mail) { NotificationMailer.notify(user, question) }

    it "renders the headers" do
      expect(mail.subject).to eq 'New answer to question!'
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq ['qna@mail.com']
    end

    it "renders the body" do
      expect(mail.body.encoded).to match('There is a new answer to the question:')
    end
  end
end
