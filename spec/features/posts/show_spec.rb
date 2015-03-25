require "rails_helper"

feature "Single post page" do
  let(:user) { create(:user, :confirmed) }
  let(:group) { create(:group) }
  let!(:post) { create(:post, :text, :published, group: group) }

  before(:each) do
    switch_to_subdomain(group.subdomain)
    sign_in(user.email, "123456")
    visit root_path
  end

  after { switch_to_main }

  scenario "I visit single post page", js: true do
    within("#post_#{post.id}") do
      click_link post.title
    end

    expect(current_path).to eq("/posts/#{post.title.parameterize}")

    within("#post_#{post.id}") do
      expect(page).to have_css(".post-title", text: post.title)
      expect(page).to have_css(".post-body", text: post.body)

      find("a.share").click
      expect(page).to have_css("ul.dropdown-menu", visible: true)
    end

    within("ul.dropdown-menu") do
      facebook_share_link = page.find(".share-on-facebook")
      expect(facebook_share_link["data-title"]).to eql post.title
      expect(facebook_share_link["data-link"]).to include(group.subdomain)
      expect(facebook_share_link["data-link"]).to include(post.slug)

      twitter_share_link = page.find(".share-on-twitter")
      expect(twitter_share_link["href"]).to include(post.slug)
      expect(twitter_share_link["href"]).to include(URI.encode(post.title))
      expect {
        twitter_share_link.click
      }.to change { Capybara.current_session.windows.size }.by(1)
    end

    new_window = Capybara.current_session.windows.last

    page.within_window new_window do
      url = URI.parse(page.current_url)
      expect(url.host).to include("twitter")
    end
  end

  context "when I'm logged in" do
    scenario "I upvote for a post", js: true do
      expect(post.cached_votes_total).to eq(0)

      page.find("#post_#{post.id} .vote").click
      wait_for_ajax
      expect(post.reload.cached_votes_total).to eql 1

      within("#post_#{post.id} .vote-count") do
        expect(page).to have_content(1)
      end

      expect {
        page.find("#post_#{post.id} .vote").click
        wait_for_ajax
      }.not_to change { post.cached_votes_total }
    end
  end

  context "when I'm not logged in" do
    background do
      click_link "Sign out"
      visit post_path(post)
    end

    scenario "I can't upvote for a post" do
      expect(page.find(".vote")["href"]).to eq(new_user_registration_path)
    end
  end
end
