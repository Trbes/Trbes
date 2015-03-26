require "rails_helper"

feature "Create post", js: true do
  include_context "group membership and authentication"

  context "when I'm approved member" do
    background do
      user.membership_for(group).member!
      visit root_path
    end

    context "with valid data" do
      scenario "I post to group" do
        create_link_post

        expect(user.posts.last.state).to eq("published")
      end
    end

    context "with invalid data" do
      scenario "I can't post to group" do
        page.find("#btn_add_post").click
        click_button "Publish Post"

        expect(page).to have_content("This field is required.")
      end
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
