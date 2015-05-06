require "rails_helper"

feature "Delete comments" do
  include_context "group membership and authentication"

  let!(:post) { create(:post, group: group) }
  let!(:comment) { create(:comment, post: post) }

  background do
    membership.moderator!
    visit post_path(post)
  end

  scenario "Delete comment from post page", js: true do
    within("#comment_#{comment.id}") do
      click_link "Delete"
    end

    expect(page).to have_content("Comment has been deleted")
    expect(post.reload.comments).to be_empty
  end
end
