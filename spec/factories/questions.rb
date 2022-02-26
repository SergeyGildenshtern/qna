FactoryBot.define do
  sequence :title do |n|
    "Question №#{n}"
  end

  factory :question do
    title
    body { 'MyText' }
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
