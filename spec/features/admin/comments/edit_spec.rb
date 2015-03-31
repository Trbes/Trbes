require "rails_helper"

feature "Edit comment from admin section" do
  include_context "group membership and authentication"

  let(:post) { create(:post, group: group) }
  let!(:comment) { create(:comment, post: post) }

  before do
    membership.owner!
  end

  scenario "Edit comment", js: true do
    visit admin_comments_path

    within("#comment_#{comment.id}") do
      click_link "edit"
    end

    fill_in "comment_body", with: "New body"
    click_button "Save"

    within("#comment_#{comment.id}") do
      expect(page).to have_content("New body")
    end
  end
end
