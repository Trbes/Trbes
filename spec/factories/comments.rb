# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    body { Faker::Hacker.say_something_smart }
    post
    user

    state :published
  end
end
