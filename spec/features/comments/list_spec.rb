require "rails_helper"

feature "Comments list" do
  include_context "group membership and authentication"

  let!(:post) { create(:post, group: group) }

  background do
    visit post_path(post)
  end

  context "when I'm group moderator" do
    scenario "I can see comments with 'moderation' status" do

    end

    scenario "I can see comments with 'moderation' status" do

    end
  end

  context "when I'm not group moderator" do
    scenario "I can see my own comments with 'moderation' status" do

    end

    scenario "I can't see other user's comments with 'moderation' status" do

    end

    scenario "I can't see unpublished comments" do

    end
  end
end
