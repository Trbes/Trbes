require "rails_helper"

feature "Sidebar" do
  let!(:group) { create(:group) }
  background do
    visit root_path
  end

  scenario "search", js: true do
    page.find(".navbar-brand").click

    within(".tt-dropdown-menu", visible: false) do
      expect(page).not_to have_content(group.name.upcase)
    end

    fill_in("Search for groups", with: group.name[0])

    within(".tt-dropdown-menu") do
      expect(page).to have_content(group.name.upcase)
    end
  end
end
