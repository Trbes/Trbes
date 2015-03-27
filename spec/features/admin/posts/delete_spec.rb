require "rails_helper"

feature "Delete post from admin section" do
  include_context "group membership and authentication"

  let!(:post) { create(:post, :published, group: group) }

  before do
    membership.owner!
  end

  scenario "Delete post" do
    visit admin_posts_path

    within("#post_#{post.id}") do
      expect {
        click_link "delete"
      }.to change { Post.count }.from(1).to(0)
    end
  end
end
