FactoryGirl.define do
  factory :group do
    name Faker::Company.name
    description Faker::Company.catch_phrase
    subdomain Faker::Internet.domain_word
    private false
  end
end
