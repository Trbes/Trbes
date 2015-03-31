require "rails_helper"

feature "Posts list" do
  include_context "group membership and authentication"

  let!(:post) { create(:post, group: group) }

  background do
    visit root_path
  end

  context "text post" do
    include ActionView::Helpers

    let!(:post) { create(:post, :text, group: group) }

    scenario "I visit posts page" do
      within("#post_#{post.id}") do
        expect(page).to have_css(".title", text: post.title)
        expect(page).to have_css(".excerpt", text: truncate(post.body, length: 160))
      end
    end
  end

  context "link post" do
    let!(:post) { create(:post, :link, group: group) }

    scenario "I visit posts page" do
      within("#post_#{post.id}") do
        expect(page).to have_css(".title", text: post.title)
        expect(page).to have_css(".url", text: post.link)
        expect(page).to have_content(post.body)
      end
    end
  end

  context "image post" do
    let!(:post) { create(:post, :image, group: group) }

    scenario "I visit posts page" do
      within("#post_#{post.id}") do
        expect(page).to have_css(".title", text: post.title)
        expect(page).to have_css(".image-wrapper")
      end
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

  context "when there are too much posts" do
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

  describe "filtering" do
    let!(:collection) { create(:collection, :visible, group: group) }
    let!(:another_collection) { create(:collection, :visible, group: group) }
    let!(:another_post) { create(:post, group: group) }

    background do
      post.collections << collection
      another_post.collections << another_collection
      visit root_path
    end

    context "by clicking on collection within post" do
      scenario "I can filter posts by selected collection" do
        within("#post_#{post.id}") do
          page.find("#collection_#{collection.id} a").click
        end

        expect(page).to have_content(post.title)
        expect(page).not_to have_content(another_post.title)

        visit root_path

        within("#post_#{another_post.id}") do
          page.find("#collection_#{another_collection.id} a").click
        end

        expect(page).to have_content(another_post.title)
        expect(page).not_to have_content(post.title)
      end
    end

    context "by clicking on collection within collections list" do
      scenario "I can filter posts by selected collection" do
        within(".nav-collections") do
          page.find("#collection_#{collection.id}").click
        end

        expect(page).to have_content(post.title)
        expect(page).not_to have_content(another_post.title)

        within(".nav-collections") do
          page.find("#collection_#{another_collection.id}").click
        end

        expect(page).to have_content(another_post.title)
        expect(page).not_to have_content(post.title)
      end
    end
  end

  context "when I'm usual member" do
    let!(:collection) { create(:collection, :visible, group: group) }

    background do
      membership.member!
      visit root_path
    end

    scenario "I can't see any collection-management-related controls on page" do
      within("#post_#{post.id}") do
        expect(page).not_to have_css(".add-to-collection")
        expect(page).not_to have_css(".remove-from-collection")
      end

      page.find(".dropdown-toggle").click

      expect(page).not_to have_content("Add Collection")
    end
  end

  context "when I'm group owner" do
    let!(:collection) { create(:collection, :visible, group: group) }

    background do
      membership.owner!
      visit root_path
    end

    scenario "I can add post to collection", js: true do
      within("#post_#{post.id}") do
        page.find(".add-to-collection", visible: false).click
      end

      select(collection.name, from: "Select a collection")
      click_button "Add"

      within("#post_#{post.id}") do
        expect(page).to have_css("#collection_#{collection.id}")
      end

      expect(post.reload.collections).to eq([collection])
    end

    scenario "I can remove post from collection" do
      post.collections << collection

      visit root_path

      within("#post_#{post.id} #collection_#{collection.id}") do
        page.find(".remove-from-collection").click
      end

      within("#post_#{post.id}") do
        expect(page).not_to have_css("#collection_#{collection.id}")
      end

      expect(post.reload.collections).to be_empty
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
