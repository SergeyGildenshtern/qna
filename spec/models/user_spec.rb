require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  context 'verification of user authorship' do
    let(:user) { create(:user) }
    let(:question1) { create(:question, author: user) }
    let(:question2) { create(:question) }

    it 'user is author' do
      expect(user.author?(question1)).to be_truthy
    end

    it 'user is not author' do
      expect(user.author?(question2)).to be_falsey
    end
  end
end
