require "rails_helper"

describe ApplicationController do
  include GroupsHelper
  include ApplicationHelper

  controller do
    before_action :ensure_group_access_from_canonical_url!, only: [:index]

    def index
      head :ok
    end
  end

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

    it "should return the right group when accessing from subdomain" do
      @request.host = "test.anything.com"
      expect(controller.current_group).to eql group_with_subdomain
    end

    it "should not allow accessing another group through custom domain" do
      allow(controller).to receive(:ensure_email_is_exists).and_return(nil)

      @request.host = "test.test2.com"
      expect(controller.current_group).to eql group_with_subdomain
      get :index
      expect(response).to redirect_to(group_url(group_with_subdomain))
    end
  end
end
