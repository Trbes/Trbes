# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    body { Faker::Hacker.say_something_smart }
    post
    user

    trait :published do
      state :published
    end
  end
end
