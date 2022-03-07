require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author) }

  it { should validate_presence_of :body }

  describe 'Update best answer' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:other_answer) { create(:answer, question: question) }

    it 'Best answer is not set' do
      answer.update_best!

      expect(answer.best).to be_truthy
    end

    it 'Best answer is set' do
      other_answer.update_best!

      expect(other_answer.best).to be_truthy
      expect(answer.best).to be_falsey
    end
  end
end
