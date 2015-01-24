ENV["RAILS_ENV"] ||= "test"
require "spec_helper"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"

# Run codeclimate-test-reporter only in CI
if ENV["CI"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

CarrierWave.configure do |config|
  config.storage = :file
  config.enable_processing = false
end

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.include FactoryGirl::Syntax::Methods
  config.include Formulaic::Dsl
  config.include LoginHelpers

  config.before do
    ActionMailer::Base.deliveries.clear
  end
end
