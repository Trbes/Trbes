FactoryGirl.define do
  factory :post do
    group
    user

    trait :text do
      after(:build) { |post| post.postable = create(:text_postable) }
    end

    trait :link do
      after(:build) { |post| post.postable = create(:link_postable) }
    end

    trait :image do
      after(:build) { |post| post.postable = create(:image_postable) }
    end
  end
end
