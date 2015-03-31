require "rails_helper"

feature "Filter posts" do
  include_context "group membership and authentication"

  let!(:post) { create(:post, group: group) }

  background do
    visit root_path
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
end
