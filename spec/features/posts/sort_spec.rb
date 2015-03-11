require "rails_helper"

feature "Sort posts list" do
  let(:user) { create(:user, :confirmed) }
  let(:group) { create(:group, users: [user]) }
  let!(:old_popular_post) { create(:post, :published, created_at: 5.days.ago, cached_votes_total: 100, group: group) }
  let!(:fresh_post) { create(:post, :published, created_at: DateTime.now, cached_votes_total: 50, group: group) }
  let!(:popular_but_not_fresh_post) { create(:post, :published, created_at: 1.day.ago, cached_votes_total: 150, group: group) }

  background do
    switch_to_subdomain(group.subdomain)
    sign_in(user.email, "123456")
    visit root_path
  end

  after { switch_to_main }

  scenario "Sort by 'Popular'" do
    click_link "Popular"

    expect(page.all(".post .title")[0].text).to eq(popular_but_not_fresh_post.title)
    expect(page.all(".post .title")[1].text).to eq(old_popular_post.title)
    expect(page.all(".post .title")[2].text).to eq(fresh_post.title)
  end

  scenario "Sort by 'New'" do

  end
end
