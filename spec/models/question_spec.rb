require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:author) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe 'Get best answer for question' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    it 'Best answer is not set' do
      expect(question.best_answer).to be_nil
    end

    it 'Best answer is set' do
      answer.update(best: true)

      expect(question.best_answer).to eq answer
    end
  end

  describe 'Get all answers without best answer' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:other_answer) { create(:answer, question: question) }

    it 'Best answer is not set' do
      expect(question.answers_without_best).to eq [answer, other_answer]
    end

    it 'Best answer is set' do
      answer.update(best: true)

      expect(question.answers_without_best).to eq [other_answer]
    end
  end
end
