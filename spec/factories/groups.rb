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

    allow_image_posts { rand < 0.5 }
    allow_link_posts { rand < 0.5 }
    allow_text_posts { rand < 0.5 }
  end
end
