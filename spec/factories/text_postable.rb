FactoryGirl.define do
  factory :text_postable do
    title { Faker::Hacker.say_something_smart }
    body { Faker::Lorem.paragraph(10) }

    after(:build) { |postable| create(:attachment, attachable: postable) }
  end
end