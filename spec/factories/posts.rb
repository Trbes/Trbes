FactoryGirl.define do
  factory :post do
    post_type :link_post
    link { Faker::Internet.url }
    title { Faker::Hacker.say_something_smart[0..99] }
    body { Faker::Lorem.paragraph(10) }

    group
    membership

    state :published

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
      link { Faker::Internet.url }
      body { Faker::Hacker.say_something_smart }
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
