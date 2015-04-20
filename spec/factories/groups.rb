FactoryGirl.define do
  factory :group do
    sequence :name do |n|
      "#{Faker::Company.name} #{n}"
    end

    tagline { Faker::Company.catch_phrase }
    description { Faker::Company.catch_phrase }

    sequence :subdomain do |n|
      "#{Faker::Internet.domain_word[0..15]}#{n}"
    end

    trait :with_owner do
      after(:build) do |group|
        group.memberships << create(:membership, role: :owner)
      end
    end

    private false

    allow_image_posts { true }
    allow_link_posts { true }
    allow_text_posts { true }

    logo { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec", "support", "trbes.png")) }
  end
end
