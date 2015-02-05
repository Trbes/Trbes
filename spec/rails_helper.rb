ENV["RAILS_ENV"] ||= "test"
require "spec_helper"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "pundit/rspec"

require "algolia/webmock"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("spec/shared/**/*.rb")].each { |f| require f }

server = FakeAlgoliaSearch.boot
ALGOLIA_HOSTS = [[server.host, server.port].join(":")]
DEFAULT_HOST = "lvh.me"
DEFAULT_PORT = 9887

CarrierWave.configure do |config|
  config.storage = :file
  config.enable_processing = false
end

RSpec.configure do |config|
  Capybara.default_host = "#{DEFAULT_HOST}"
  Capybara.server_port = DEFAULT_PORT
  Capybara.app_host = "#{DEFAULT_HOST}:#{DEFAULT_PORT}"

  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.include FactoryGirl::Syntax::Methods
  config.include Formulaic::Dsl
  config.include FeatureHelpers, type: :feature
  config.include ControllerHelpers, type: :controller

  config.before do
    WebMock.enable!
    WebMock.disable_net_connect!(allow_localhost: true)
    WebMock.stub_request(:get, %r{.*\.algolia\.(io|net)\/1\/indexes\/[^\/]+})
      .to_return(body: '{ "hits": [ { "objectID": 42 } ], "page": 1, "hitsPerPage": 1 }')
    allow(Cloudinary::Utils).to receive(:cloudinary_url).and_return("")
    ActionMailer::Base.deliveries.clear
  end

  config.after do
    WebMock.disable!
  end
end
