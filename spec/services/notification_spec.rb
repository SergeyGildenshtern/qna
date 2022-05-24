require 'rails_helper'

RSpec.describe NotificationService do
  let!(:question) { create(:question, author: create(:user)) }
  let!(:mailings) { create_list(:mailing, 3, question: question, user: create(:user)) }

  it 'sends notification to all subscribers' do
    question.mailings.each do |mailing|
      expect(NotificationMailer).to receive(:notify).with(mailing.user, question).and_call_original
    end
    subject.send_notify question
  end
end
