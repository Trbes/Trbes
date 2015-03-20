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

  def create_link_post
    page.find("#btn_add_post").click

    page.find("#select_post_type").click
    click_link "Link"

    fill_in "Link", with: "http://sample-link.com"
    fill_in "Title", with: "Long enough title"
    fill_in "Tagline", with: "Tagline"

    click_button "Publish Post"

    expect(page).to have_content("Long enough title")
  end

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

  context "when I'm owner on admin page" do
    background do
      user.membership_for(group).owner!
      visit admin_dashboard_index_path
    end

    scenario "I post to group" do
      create_link_post

      expect(user.posts.last.state).to eq("published")
    end
  end
end
