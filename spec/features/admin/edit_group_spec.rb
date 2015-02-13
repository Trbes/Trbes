require "rails_helper"

feature "Admin group page" do
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

    scenario "I can visit admin group page" do
      click_button("group_menu")
      click_link("Edit Group")
      click_link("Group")

      expect(current_path).to eq(edit_admin_group_path)
    end
  end
end
