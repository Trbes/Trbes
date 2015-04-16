require "rails_helper"

feature "Sort posts list" do
  include_context "group membership and authentication"

  let!(:old_popular_post) { create(:post, created_at: 5.days.ago, cached_votes_total: 100, group: group) }
  let!(:same_popular_as_old_but_newer_post) do
    create(:post, created_at: 1.day.ago, cached_votes_total: 100, group: group)
  end
  let!(:fresh_post) { create(:post, created_at: DateTime.now, cached_votes_total: 50, group: group) }
  let!(:very_popular_but_not_so_fresh_post) do
    create(:post, created_at: 4.hours.ago, cached_votes_total: 250, group: group)
  end

  background do
    visit root_path
  end

  scenario "Sort by 'Popular'" do
    click_link "Popular"

    expect(page.all(".post .title")[0].text).to eq(very_popular_but_not_so_fresh_post.title)
    expect(page.all(".post .title")[1].text).to eq(same_popular_as_old_but_newer_post.title)
    expect(page.all(".post .title")[2].text).to eq(old_popular_post.title)
    expect(page.all(".post .title")[3].text).to eq(fresh_post.title)
  end

  scenario "Sort by 'New'" do
    click_link "New"

    expect(page.all(".post .title")[0].text).to eq(fresh_post.title)
    expect(page.all(".post .title")[1].text).to eq(very_popular_but_not_so_fresh_post.title)
    expect(page.all(".post .title")[2].text).to eq(same_popular_as_old_but_newer_post.title)
    expect(page.all(".post .title")[3].text).to eq(old_popular_post.title)
  end

  scenario "Sort by 'Trending'" do
    click_link "Trending"

    expect(page.all(".post .title")[0].text).to eq(very_popular_but_not_so_fresh_post.title)
    expect(page.all(".post .title")[1].text).to eq(fresh_post.title)
    expect(page.all(".post .title")[2].text).to eq(same_popular_as_old_but_newer_post.title)
    expect(page.all(".post .title")[3].text).to eq(old_popular_post.title)
  end
end
