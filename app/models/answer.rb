class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  def update_best!
    question.best_answer&.update(best: false)
    update(best: true)
  end
end
