FactoryGirl.define do
  factory :membership do
    association :user, factory: [:user, :confirmed]
    group
  end
end
