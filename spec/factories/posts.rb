FactoryGirl.define do
  factory :post do
    group
    user
    after(:build) { |post| post.postable = create %i( text_postable link_postable image_postable ).sample }
  end
end
