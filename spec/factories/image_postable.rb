FactoryGirl.define do
  factory :image_postable do
    title { Faker::Hacker.say_something_smart }
    after(:build) { |postable| create(:attachment, attachable: postable) }
  end
end
