require "rails_helper"

feature "Create post", js: true do
  include_context "group membership and authentication"

  context "when I'm approved member" do
    background do
      user.membership_for(group).member!
      visit root_path
    end

    scenario "I post to group" do
      create_link_post

      expect(user.posts.last.state).to eq("published")
    end
  end

  context "when I'm pending member" do
    background do
      user.membership_for(group).pending!
      visit root_path
    end

    scenario "I post to group" do
      create_link_post

      expect(user.posts.last.state).to eq("moderation")
    end
  end
end
