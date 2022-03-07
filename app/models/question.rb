class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  validates :title, :body, presence: true

  def best_answer
    answers.find_by(best: true)
  end

  def answers_without_best
    answers.without best_answer
  end
end
