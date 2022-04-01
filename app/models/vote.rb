class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates_inclusion_of :status, in: [1, -1]
end
