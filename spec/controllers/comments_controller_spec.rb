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
      delete :destroy, id: comment.id, post_id: some_post.id
    end

    it "redirects to post" do
      expect(controller).to redirect_to(some_post)
    end
  end
end
