FactoryBot.define do
  factory :reward do
    question
    name { "RewardName" }
    image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/image.jpg") }
  end
end
