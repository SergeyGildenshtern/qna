require 'rails_helper'
require 'models/concerns/votable'
require 'models/concerns/commentable'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { should belong_to(:author) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:mailings).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'After create' do
    let(:user) { create(:user) }

    it "create new mailing" do
      question = build(:question, author: user)
      expect(Mailing).to receive(:create).with(question: question, user: question.author)
      question.save
    end
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

  describe 'Get all yesterday questions' do
    let!(:today_questions) { create_list(:question, 3) }
    let!(:yesterday_questions) { create_list(:question, 3, created_at: 1.day.ago) }

    it 'return yesterday questions' do
      expect(Question.yesterday_questions).to eq yesterday_questions
    end

    it 'does not return today questions' do
      expect(Question.yesterday_questions).to_not eq today_questions
    end
  end
end
