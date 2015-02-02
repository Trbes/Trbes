FactoryGirl.define do
  factory :collection do
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec", "support", "trbes.png")) }

    sequence :name do |n|
      "#{Faker::Internet.domain_suffix} #{n}"
    end

    description { Faker::Company.catch_phrase }

    group
  end
end