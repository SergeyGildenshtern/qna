class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, foreign_key: 'author_id', dependent: :destroy
  has_many :answers, foreign_key: 'author_id', dependent: :destroy
  has_many :comments, foreign_key: 'author_id', dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :mailings, dependent: :destroy

  def author?(obj)
    obj.author_id == id
  end

  def subscribed?(question)
    mailing(question).present?
  end

  def mailing(question)
    mailings.find_by(question: question)
  end
end
