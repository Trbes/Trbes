require "rails_helper"

describe "With a mocked client" do
  it "shouldn't perform any API calls here" do
    create(:group) # mocked, no API call performed
    expect(Group.search("")).to be_empty # mocked, no API call performed
  end
end
