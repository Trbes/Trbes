require "rails_helper"

describe GroupsController do
  let(:group_with_subdomain) { Group.first }

  before do
    stub_auth
  end

  describe "#ensure_group_access_from_canonical_url" do
    before do
      allow(controller).to receive(:ensure_email_is_exists).and_return(nil)
      @request.host = "test.test2.com"
      get :show, subdomain: group_with_subdomain.subdomain
    end

    it "should not allow accessing another group through custom domain" do
      expect(controller.current_group).to eq(group_with_subdomain)
      expect(response).to redirect_to(root_url(subdomain: group_with_subdomain.subdomain))
    end
  end
end
