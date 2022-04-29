require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:mailings).dependent(:destroy) }

  describe 'Verification of user authorship' do
    let(:user) { create(:user) }
    let(:question1) { create(:question, author: user) }
    let(:question2) { create(:question) }

    it 'user is author' do
      expect(user).to be_author(question1)
    end

    it 'user is not author' do
      expect(user).to_not be_author(question2)
    end
  end

  describe 'Getting the user subscription' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: create(:user)) }

    it 'user is unsubscribed' do
      expect(user.mailing(question)).to eq nil
    end

    it 'user is subscribed' do
      expect(question.author.mailing(question)).to eq question.mailings.first
    end
  end

  describe 'Checking the user subscription' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: create(:user)) }

    it 'user is unsubscribed' do
      expect(user).to_not be_subscribed(question)
    end

    it 'user is subscribed' do
      expect(question.author).to be_subscribed(question)
    end
  end
end
