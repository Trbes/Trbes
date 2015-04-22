require "rails_helper"

feature "Create collection" do
  let(:user) { create(:user, :confirmed) }
  let(:group) { create(:group, users: [user]) }

  background do
    switch_to_subdomain(group.subdomain)
    sign_in(user.email, "12345678")
  end

  context "when I'm group owner", js: true do
    background do
      user.membership_for(group).owner!
      visit edit_admin_group_path
    end

    scenario "I can create a collection", js: true do
      within(".collections") do
        click_link "Add"
      end

      fill_in "Name", with: "Name"
      page.find("a.select-icon-class:first-child").click

      click_button "Save"

      expect(page).to have_content("Group")
      expect(page).to have_content('Collection "Name" has been added')
      expect(Collection.count).to eq(1)
      expect(current_path).to eq(edit_admin_group_path)
    end
  end
end
