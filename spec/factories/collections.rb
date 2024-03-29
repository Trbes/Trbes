FactoryGirl.define do
  factory :collection do
    sequence :name do |n|
      "#{Faker::Internet.domain_suffix} #{n}"
    end

    sequence :icon_class do |n|
      "icon #{n}"
    end

    description { Faker::Company.catch_phrase }

    group

    trait :visible do
      visibility { true }
    end
  end
end
