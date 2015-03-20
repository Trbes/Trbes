FactoryGirl.define do
  factory :group do
    sequence :name do |n|
      "#{Faker::Company.name} #{n}"
    end

    tagline { Faker::Company.catch_phrase }
    description { Faker::Company.catch_phrase }

    sequence :subdomain do |n|
      "#{Faker::Internet.domain_word}#{n}"
    end

    private false

    allow_image_posts { true }
    allow_link_posts { true }
    allow_text_posts { true }

    after(:build) do |group|
      group.logo = build(:attachment, attachable: group)
    end

    after(:create) do |group|
      group.logo.save!
    end
  end
end
