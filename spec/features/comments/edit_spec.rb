require "rails_helper"

feature "Edit comment" do
  include_context "group membership and authentication"

  let!(:post) { create(:post, group: group) }
  let!(:comment) { create(:comment, post: post) }

  background do
    membership.moderator!
    visit post_path(post)
  end

  scenario "Edit comment from post page", js: true do
    within("#comment_#{comment.id}") do
      click_link "Edit"
    end

    fill_in "Comment", with: "New Body"

    click_button "Save"

    expect(page).to have_content("Comment was successfully updated")
    expect(comment.reload.body).to eq("New Body")
  end
end
