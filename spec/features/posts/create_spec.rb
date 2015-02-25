require "rails_helper"

feature "Create post", js: true do
  let(:user) { create(:user, :confirmed) }
  let(:group) { create(:group) }

  background do
    switch_to_subdomain(group.subdomain)
    sign_in(user.email, "123456")
    group.users << user
  end

  after { switch_to_main }

  def create_post
    page.find("#btn_add_post").click

    fill_in "Title", with: "Long enough title"
    fill_in "Your Text", with: "Your Text"

    click_button "Publish Post"

    expect(page).to have_content("Long enough title")
  end

  context "when I'm approved member" do
    background do
      user.membership_for(group).member!
      visit root_path
    end

    scenario "I post to group" do
      create_post

      expect(user.posts.last.state).to eq("published")
    end
  end

  context "when I'm pending member" do
    background do
      user.membership_for(group).pending!
      visit root_path
    end

    scenario "I post to group" do
      create_post

      expect(user.posts.last.state).to eq("moderation")
    end
  end
end
