FactoryGirl.define do
  factory :post do
    group
    user
    association(:postable, factory: :text_postable)
  end
end
