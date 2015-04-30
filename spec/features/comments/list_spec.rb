require "rails_helper"

feature "Comments list" do
  include_context "group membership and authentication"

  let!(:post) { create(:post, group: group) }

  let!(:my_comment_on_moderation) { create(:comment, post: post, state: "moderation", membership: membership) }
  let!(:other_comment_on_moderation) { create(:comment, post: post, state: "moderation") }
  let!(:published_comment) { create(:comment, post: post, state: "published") }

  context "when I'm group moderator" do
    background do
      membership.moderator!
      visit post_path(post)
    end

    scenario "I can see all comments for this post" do
      within(".comments") do
        expect(page).to have_content(my_comment_on_moderation.body)
        expect(page).to have_content(other_comment_on_moderation.body)
        expect(page).to have_content(published_comment.body)
      end
    end
  end

  context "when I'm not group moderator" do
    background do
      membership.member!
      visit post_path(post)
    end

    scenario "I can see only published or my own comments with 'moderation' status" do
      expect(page).to have_content(my_comment_on_moderation.body)
      expect(page).not_to have_content(other_comment_on_moderation.body)
      expect(page).to have_content(published_comment.body)
    end
  end
end
