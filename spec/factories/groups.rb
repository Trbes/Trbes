FactoryGirl.define do
  factory :group do
    sequence :name do |n|
      "#{Faker::Company.name} #{n}"
    end

    description { Faker::Company.catch_phrase }

    sequence :subdomain do |n|
      "#{Faker::Internet.domain_word}#{n}"
    end

    private false
  end
end
