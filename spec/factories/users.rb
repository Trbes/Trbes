FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    full_name { Faker::Name.name }
    title { Faker::Name.title }
    password "123456"
    password_confirmation "123456"
  end

  trait :confirmed do
    confirmed_at 1.hour.ago
  end

  trait :not_confirmed do
    confirmed_at nil

    after(:create) do |user|
      user.update_attributes(confirmation_sent_at: 3.days.ago)
    end
  end
end
