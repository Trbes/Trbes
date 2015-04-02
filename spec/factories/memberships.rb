FactoryGirl.define do
  factory :membership do
    association :user, factory: %i(user confirmed)
    group
  end
end
