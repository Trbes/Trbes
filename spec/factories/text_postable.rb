FactoryGirl.define do
  factory :text_postable do
    title { Faker::Hacker.say_something_smart }
    body { Faker::Lorem.paragraph(10) }

    after(:build) do |postable|
      postable.attachments = [build(:attachment, attachable: postable)]
    end

    after(:create) do |postable|
      postable.attachments.each(&:save!)
    end
  end
end
