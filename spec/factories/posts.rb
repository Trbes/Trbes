FactoryGirl.define do
  factory :post do
    title { Faker::Hacker.say_something_smart }
    body { Faker::Lorem.paragraph(10) }
    group
    user
  end
end
