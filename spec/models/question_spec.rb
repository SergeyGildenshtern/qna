require 'rails_helper'
require 'models/concerns/votable_spec'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'

  it { should belong_to(:author) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

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
