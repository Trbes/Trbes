require "rails_helper"

feature "Posts list" do
  include_context "group membership and authentication"

  let!(:post) { create(:post, group: group) }

  background do
    visit root_path
  end

  context "there is pending post", js: true do
    let!(:pending_post) { create(:post, state: :moderation, group: group, membership: membership) }

    context "when I'm moderator" do
      background do
        membership.moderator!
        visit root_path
      end

      scenario "I can see pending post" do
        expect(page).to have_css("#post_#{pending_post.id}")
      end
    end

    context "when I'm just member (post author)" do
      background do
        membership.member!
        visit root_path
      end

      scenario "I can see pending post" do
        expect(page).to have_css("#post_#{pending_post.id}")
      end
    end

    context "when I'm just member (not a post author)" do
      background do
        membership.member!
        pending_post.update_attributes(membership: create(:membership))
        visit root_path
      end

      scenario "I can't see pending post" do
        expect(page).not_to have_css("#post_#{pending_post.id}")
      end
    end
  end

  context "text post", js: true do
    include ActionView::Helpers

    let!(:post) { create(:post, :text, group: group) }

    scenario "I visit posts page" do
      within("#post_#{post.id}") do
        expect(page).to have_css(".title", text: post.title)
        expect(page.find(".excerpt").text[0..100]).to eql post.body[0..100]
      end
    end
  end

  context "link post", js: true do
    let!(:post) { create(:post, :link, group: group) }

    scenario "I visit posts page" do
      within("#post_#{post.id}") do
        expect(page).to have_css(".title", text: post.title)
        expect(page).to have_css(".url", text: post.link)
        expect(page).to have_content(post.body)
      end
    end
  end

  context "image post", js: true do
    let!(:post) { create(:post, :image, group: group) }

    scenario "I visit posts page" do
      within("#post_#{post.id}") do
        expect(page).to have_css(".title", text: post.title)
        expect(page).to have_css(".image-wrapper")
      end
    end
  end

  scenario "Search", js: true, driver: :webkit do
    within(".tt-dropdown-menu", visible: false) do
      expect(page).not_to have_content(post.title)
    end

    fill_in("Search for posts", with: post.title[0])

    within(".tt-dropdown-menu") do
      expect(page).to have_content(post.title)
    end
  end

  scenario "I can vote and unvote", js: true do
    within("#post_#{post.id}") do
      vote_link = page.find(".vote")
      vote_link.click
      expect(page).to have_css(".vote.done")
      expect(post.reload.cached_votes_total).to eql 1

      vote_link.click
      expect(page).not_to have_css(".vote.done")
      expect(post.reload.cached_votes_total).to eql 0
    end
  end

  context "when there are too much posts", js: true do
    background do
      create_list(:post, 20, group: group)
      visit root_path
    end

    scenario "pagination happens" do
      expect(page).to have_css(".post", count: 20)

      within(".pagination") do
        click_link "Next"
      end

      expect(page).to have_css(".post", count: 1)
    end
  end

  context "when I'm not logged in" do
    background do
      click_link "Sign out"
      visit post_path(post)
    end

    scenario "I can't vote" do
      within("#post_#{post.id}") do
        expect(page.find(".vote")["href"]).to eq(new_user_registration_path)
      end
    end
  end
end
