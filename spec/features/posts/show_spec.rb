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

  scenario "I visit single post page" do
    within("#post_#{post.id}") do
      expect(page).to have_css(".title", text: post.title)
      expect(page).to have_css(".excerpt", text: post.body)

      click_link post.title
    end

    expect(current_path).to eq("/posts/#{post.title.parameterize}")

    within("#post_#{post.id}") do
      expect(page).to have_css(".post-title", text: post.title)
      expect(page).to have_css(".post-body", text: post.body)
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
      expect(page.find(".vote")["href"]).to eq("#")
    end
  end
end
