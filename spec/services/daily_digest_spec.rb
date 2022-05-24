require 'rails_helper'

RSpec.describe DailyDigestService do
  let!(:users) { create_list(:user, 3) }
  let!(:questions) { create_list(:question, 3, created_at: 1.day.ago, author: users.first) }

  it 'sends daily digest to all users' do
    users.each do |user|
      expect(DailyDigestMailer).to receive(:digest).with(user, questions).and_call_original
    end
    subject.send_digest
  end
end
