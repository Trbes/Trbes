FactoryGirl.define do
  factory :attachment do
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec", "support", "trbes.png")) }
  end
end
