require "rails_helper"

feature "Single post page" do
  let(:user) { create(:user, :confirmed) }
  let(:group) { create(:group) }
  let!(:post) { create(:post, :text, group: group) }

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
      expect(page).to have_css(".title", text: post.title)
      expect(page).to have_css(".excerpt", text: post.body)
    end
  end

  scenario "I upvote for a post" do
    expect(post.cached_votes_total).to eq(0)

    expect {
      page.find("#post_#{post.id} .vote").click
      post.reload
    }.to change { post.cached_votes_total }.from(0).to(1)

    within("#post_#{post.id} .vote-count") do
      expect(page).to have_content(1)
    end

    expect {
      page.find("#post_#{post.id} .vote").click
      post.reload
    }.not_to change { post.cached_votes_total }
  end
end
