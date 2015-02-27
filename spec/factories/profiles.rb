FactoryGirl.define do
  factory :profile do
    user
    provider "Facebook"
    uid "123"
  end
end
