FactoryBot.define do
  factory :link do
    association :linkable, factory: %i[question answer]
    name { "google" }
    url { "https://www.google.ru/" }
  end
end
