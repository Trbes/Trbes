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

    allow_image_posts { [true, false].sample }
    allow_link_posts { [true, false].sample }
    allow_text_posts { [true, false].sample }
  end
end
