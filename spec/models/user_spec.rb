require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

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
end
