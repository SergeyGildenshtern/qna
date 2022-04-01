FactoryBot.define do
  factory :vote do
    user
    association :votable, factory: %i[question answer]
    status { true }
  end
end
