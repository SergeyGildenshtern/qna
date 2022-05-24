class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :mailings, dependent: :destroy
  has_one :reward, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :subscribe_mailing

  scope :yesterday_questions, -> { where(created_at: 1.day.ago.all_day) }

  def best_answer
    answers.find_by(best: true)
  end

  def answers_without_best
    answers.without best_answer
  end

  private

  def subscribe_mailing
    Mailing.create(question: self, user: self.author)
  end
end
