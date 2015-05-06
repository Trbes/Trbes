require "rails_helper"

feature "Sidebar", driver: :webkit do
  include_context "group membership and authentication"

  background do
    visit root_path
  end

  scenario "Search for groups", js: true do
    page.find(".navbar-brand").trigger("click")

    within(".tt-dropdown-menu", visible: false) do
      expect(page).not_to have_content(group.name.upcase)
    end

    fill_in("Search for groups", with: group.name[0])

    within(".tt-dropdown-menu") do
      expect(page).to have_content(group.name.upcase)
    end
  end

  context "Non-logged-in User" do
    background do
      click_link user.full_name
      click_link "Sign out"
    end

    scenario "Open the sidebar", js: true do
      visit root_path

      page.find(".navbar-brand").trigger("click")

      within("#main_sliding_menu") do
        expect(page).not_to have_css(".btn-create-group")
        expect(page).not_to have_css(".my-trbes")
      end
    end
  end

  context "Logged-in User" do
    let!(:other_group) { create(:group) }

    scenario "Open the sidebar", js: true do
      visit root_path

      page.find(".navbar-brand").trigger("click")

      within("#main_sliding_menu") do
        expect(page).to have_css(".btn-create-group")
        expect(page).to have_css(".my-trbes")
        within(".my-trbes-list") do
          expect(page).to have_content(group.name.upcase)
          expect(page).not_to have_content(other_group.name.upcase)
        end
      end
    end

    scenario "Unsubscribe from group", js: true do
      visit root_path

      page.find(".navbar-brand").trigger("click")
      within("#main_sliding_menu #sidebar_group_#{group.id}") do
        page.find(".unsubscribe", visible: false).trigger("click")
      end

      expect(page).not_to have_css("#main_sliding_menu #sidebar_group_#{group.id}", visible: false)
    end
  end
end
