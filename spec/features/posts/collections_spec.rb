require "rails_helper"

feature "Manage posts and collections" do
  include_context "group membership and authentication"

  let!(:post) { create(:post, group: group) }

  background do
    visit root_path
  end

  context "when I'm usual member" do
    let!(:collection) { create(:collection, :visible, group: group) }

    background do
      membership.member!
      visit root_path
    end

    scenario "I can't see any collection-management-related controls on page", js: true do
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
        page.find(".add-to-collection", visible: false).trigger("click")
      end

      select(collection.name, from: "Select a collection")
      click_button "Add"

      within("#post_#{post.id}") do
        expect(page).to have_css("#collection_#{collection.id}")
      end

      expect(post.reload.collections).to eq([collection])
      expect(page).to have_content %(Post was added to "#{collection.name}")
    end

    scenario "I can remove post from collection", js: true do
      post.collections << collection

      visit root_path

      page.find("#post_#{post.id} #collection_#{collection.id}").hover

      within("#post_#{post.id} #collection_#{collection.id}") do
        page.find(".remove-from-collection").click
      end

      within("#post_#{post.id}") do
        expect(page).not_to have_css("#collection_#{collection.id}")
      end

      expect(post.reload.collections).to be_empty
      expect(page).to have_content %(Post was removed from "#{collection.name}")
    end
  end
end
