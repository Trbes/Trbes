FactoryGirl.define do
  factory :post do
    title { Faker::Hacker.say_something_smart }
    body { Faker::Lorem.paragraph(10) }

    group
    user

    trait :text do
      post_type :text_post

      after(:build) do |post|
        post.attachments = [build(:attachment, attachable: post)]
      end

      after(:create) do |post|
        post.attachments.each(&:save!)
      end
    end

    trait :link do
      post_type :link_post
      body { Faker::Internet.url }
    end

    trait :image do
      post_type :image_post
      body { Faker::Hacker.say_something_smart }

      after(:build) do |post|
        post.attachments = [build(:attachment, attachable: post)]
      end

      after(:create) do |post|
        post.attachments.each(&:save!)
      end
    end
  end
end
