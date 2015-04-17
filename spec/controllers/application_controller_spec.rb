require "rails_helper"

describe ApplicationController do
  describe "#current_group" do
    let!(:group_with_subdomain) { create(:group, subdomain: "test") }
    let!(:group_with_custom_domain) { create(:group, subdomain: "test2", custom_domain: "test2.com") }
    let!(:group_with_custom_domain_same_subdomain) do
      create(:group, subdomain: "test3", custom_domain: "test.example.com")
    end

    it "should return the right group when accessing from custom domain" do
      @request.host = "test2.com"
      expect(controller.current_group).to eql group_with_custom_domain
    end

    it "should search for custom domain first" do
      @request.host = "test.example.com"
      expect(controller.current_group).to eql group_with_custom_domain_same_subdomain
    end
  end
end
