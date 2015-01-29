require "rails_helper"

feature "Vote for a post" do
  let(:user) { create(:user, :confirmed) }
  let(:group) { create(:group) }
  let!(:post) { create(:post, group: group) }

  before(:each) do
    sign_in(user.email, "123456")
    visit root_url(subdomain: group.subdomain)
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
