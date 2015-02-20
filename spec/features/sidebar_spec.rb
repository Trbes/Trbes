require "rails_helper"

feature "Sidebar" do
  let!(:group) { create(:group) }

  scenario "Search for groups", js: true do
    visit "/explore"

    page.find(".navbar-brand").click

    within(".tt-dropdown-menu", visible: false) do
      expect(page).not_to have_content(group.name.upcase)
    end

    fill_in("Search for groups", with: group.name[0])

    within(".tt-dropdown-menu") do
      expect(page).to have_content(group.name.upcase)
    end
  end

  context "Non-logged-in User" do
    scenario "Open the sidebar", js: true do
      visit "/explore"

      page.find(".navbar-brand").click

      within("#main_sliding_menu") do
        expect(page).not_to have_css(".btn-create-group")
        expect(page).not_to have_css(".my-trbes")
        expect(page).not_to have_css(".favorites")
      end
    end
  end

  context "Logged-in User" do
    let(:user) { create(:user, :confirmed) }
    let!(:other_group) { create(:group) }
    background do
      group.add_member(user, as: "member")
      sign_in(user.email, "123456")
    end

    scenario "Open the sidebar", js: true do
      visit "/explore"

      page.find(".navbar-brand").click

      within("#main_sliding_menu") do
        expect(page).to have_css(".btn-create-group")
        expect(page).to have_css(".my-trbes")
        within(".my-trbes-list") do
          expect(page).to have_content(group.name.upcase)
          expect(page).not_to have_content(other_group.name.upcase)
        end
        expect(page).to have_css(".favorites")
      end
    end
  end
end
