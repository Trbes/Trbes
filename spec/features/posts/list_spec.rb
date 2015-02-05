require "rails_helper"

feature "Posts list" do
  let(:user) { create(:user, :confirmed) }
  let(:group) { create(:group) }
  let!(:post) { create(:post, :text, group: group) }

  background do
    switch_to_subdomain(group.subdomain)
    sign_in(user.email, "123456")
    visit root_path
  end

  after { switch_to_main }

  scenario "I visit posts page" do
    within("#post_#{post.id}") do
      expect(page).to have_css(".title", text: post.title)
      expect(page).to have_css(".excerpt", text: post.body)
      expect(page.find(".post-thumb img")["src"]).to have_content(post.preview_image.url)
    end
  end

  scenario "Search", js: true do
    within(".tt-dropdown-menu", visible: false) do
      expect(page).not_to have_content(post.title)
    end

    fill_in("Search for posts", with: post.title[0])

    within(".tt-dropdown-menu") do
      expect(page).to have_content(post.title)
    end
  end

  context "when there are too much posts" do
    background do
      create_list(:post, 20, :text, group: group)
      visit root_url(subdomain: group.subdomain)
    end

    scenario "pagination happens" do
      expect(page).to have_css(".post", count: 20)

      within(".pagination") do
        click_link "Next"
      end

      expect(page).to have_css(".post", count: 1)
    end
  end
end
