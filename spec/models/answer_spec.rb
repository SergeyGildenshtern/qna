require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author) }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

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
