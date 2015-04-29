require "rails_helper"

describe PostsController do
  let(:post) { Post.first }

  before do
    stub_auth

    create(:post, :text, group: Group.first)
  end

  describe "PUT #upvote" do
    before do
      put :upvote, post_id: post.slug
    end

    it "returns json with new_total_votes" do
      expect(JSON.parse(response.body)["new_total_votes"]).to eql post.reload.cached_votes_total
    end
  end
end
