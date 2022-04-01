module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote(user)
    votes.find_by(user: user)
  end

  def voted?(user)
    vote(user).present?
  end

  def rating
    votes.count { |v| v.status } - votes.count { |v| !v.status }
  end
end
