require "rails_helper"

feature "Admin dashboard" do
  include_context "group membership and authentication"

  context "when I'm group admin" do
    background do
      membership.owner!
      visit root_path
    end

    scenario "I can visit admin dashboard" do
      click_button("group_menu")
      click_link("Manage")

      expect(current_path).to eq(admin_dashboard_index_path)
    end
  end

  context "when I'm not group admin" do
    background do
      visit root_path
    end

    scenario "link to admin dashboard is not visible for me" do
      expect(page).not_to have_content("Manage", visible: false)
    end

    scenario "even if I try to load admin dashboard by URL", js: true do
      visit(admin_dashboard_index_path)
      expect(page).to have_content("Please sign in to perform this action.")
    end
  end
end
