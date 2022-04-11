FactoryBot.define do
  factory :comment do
    association :author, factory: :user
    association :commentable, factory: %i[question answer]
    text { 'MyText' }

    trait :invalid do
      text { nil }
    end
  end
end
