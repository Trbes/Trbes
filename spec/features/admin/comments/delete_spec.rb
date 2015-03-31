require "rails_helper"

feature "Delete comment from admin section" do
  include_context "group membership and authentication"

  let(:post) { create(:post, group: group) }
  let!(:comment) { create(:comment, post: post) }

  before do
    membership.owner!
  end

  scenario "Delete comment" do
    visit admin_comments_path

    within("#comment_#{comment.id}") do
      expect {
        click_link "delete"
      }.to change { Comment.count }.from(1).to(0)
    end
  end
end
