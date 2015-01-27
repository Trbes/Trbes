FactoryGirl.define do
  factory :image_postable do
    title { Faker::Hacker.say_something_smart }
  end
end
