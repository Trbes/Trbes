FactoryGirl.define do
  factory :link_postable do
    title { Faker::Hacker.say_something_smart }
    link { Faker::Internet.url }
  end
end
