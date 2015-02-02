require "rails_helper"

describe VotesController do
  let!(:post) { create(:post, :text) }

  before do
    stub_auth
  end

  describe "PUT #upvote" do
    before do
      request.env["HTTP_REFERER"] = root_url
      put :upvote, vote_id: post.id
    end

    it "redirects back" do
      expect(response).to redirect_to(:back)
    end
  end
end
