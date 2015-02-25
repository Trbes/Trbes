require "rails_helper"

feature "Posts list" do
  let(:user) { create(:user, :confirmed) }
  let(:group) { create(:group) }
  let!(:post) { create(:post, :text, :published, group: group) }

  background do
    switch_to_subdomain(group.subdomain)
    sign_in(user.email, "123456")
    visit root_path
  end

  after { switch_to_main }

  scenario "I visit posts page" do
    within("#post_#{post.id}") do
      expect(page).to have_css(".title", text: post.title)
      expect(page).to have_css(".excerpt", text: post.body)
      expect(page.find(".post-thumb img")["src"]).to have_content(post.preview_image.url)
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

  context "when there are too much posts" do
    background do
      create_list(:post, 20, :text, :published, group: group)
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
    let!(:another_post) { create(:post, :text, :published, group: group) }

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
      user.membership_for(group).member!
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
      user.membership_for(group).owner!
      visit root_path
    end

    scenario "I can add post to collection" do
      within("#post_#{post.id}") do
        page.find(".add-to-collection").click
      end

      select(collection.name, from: "Collection")
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
end
