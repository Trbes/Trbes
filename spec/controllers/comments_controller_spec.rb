require "rails_helper"

describe CommentsController do
  let!(:some_post) { create(:post, :text) }

  before do
    stub_auth
  end

  describe "POST #create" do
    let(:comment_attributes) { attributes_for(:comment) }

    before do
      post :create, post_id: some_post.id, comment: comment_attributes
    end

    it "assigns comment" do
      expect(controller.comment).to be_a(Comment)
    end

    it "redirects to comment's post" do
      expect(controller).to redirect_to(Comment.last.post)
    end
  end

  describe "DELETE #destroy" do
    let!(:comment) { create(:comment, post: some_post) }

    before do
      request.env["HTTP_REFERER"] = admin_comments_path
      delete :destroy, id: comment.id, post_id: some_post.id
    end

    it "redirects back" do
      expect(controller).to redirect_to(admin_comments_path)
    end
  end

  describe "PUT #upvote" do
    let!(:comment) { create(:comment, post: some_post) }

    before do
      put :upvote, comment_id: comment.id
    end

    it "returns json with new_total_votes" do
      expect(JSON.parse(response.body)["new_total_votes"]).to eql comment.reload.cached_votes_total
    end
  end
end
