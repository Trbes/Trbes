require "algolia/webmock"
require "rails_helper"

describe "With a mocked client" do
  before(:each) do
    WebMock.enable!
  end

  it "shouldn't perform any API calls here" do
    create(:group) # mocked, no API call performed
    expect(Group.search("")).to be_empty # mocked, no API call performed
  end

  after(:each) do
    WebMock.disable!
  end
end
