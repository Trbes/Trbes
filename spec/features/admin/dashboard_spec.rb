require "rails_helper"

feature "Admin dashboard" do
  let(:user) { create(:user, :confirmed) }
  let(:group) { create(:group, users: [user]) }

  background do
    switch_to_subdomain(group.subdomain)
    sign_in(user.email, "123456")
  end

  context "when I'm group admin" do
    background do
      user.membership_for(group).make_admin!
      visit root_path
    end

    scenario "I can visit admin dashboard" do
      click_button("group_menu")
      click_link("Edit Group")

      expect(current_path).to eq(admin_dashboard_index_path)
    end
  end

  context "when I'm not group admin" do
    background do
      visit root_path
    end

    scenario "link to admin dashboard is not visible for me" do
      click_button("group_menu")
      expect(page).not_to have_content("Edit Group")
    end

    scenario "even if I try to load admin dashboard by URL" do
      visit(admin_dashboard_index_path)
      expect(page).to have_content("You are not authorized to perform this action.")
    end
  end
end
