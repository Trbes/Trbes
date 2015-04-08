require "rails_helper"

feature "List collections" do
  include_context "group membership and authentication"

  let!(:collection) { create(:collection, :visible, group: group) }
  let!(:another_collection) { create(:collection, :visible, group: group) }

  background do
    membership.owner!
    visit edit_admin_group_path
  end

  scenario "I can view a list of collections" do
    expect(page).to have_css(".collection[data-id='#{collection.id}']")
    expect(page).to have_css(".collection[data-id='#{another_collection.id}']")
  end

  context "when there posts within this collection" do
    let!(:post) { create(:post, collections: [collection], group: group) }

    background do
      visit edit_admin_group_path
    end

    scenario "I can visit posts list within this collection" do
      within "#collection_#{collection.id}" do
        click_link "1 post"
      end

      expect(current_path).to eq(root_path)
      expect(page).to have_css("#post_#{post.id}")
    end
  end
end
