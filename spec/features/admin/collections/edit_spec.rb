require "rails_helper"

feature "Edit collection" do
  let(:user) { create(:user, :confirmed) }
  let(:group) { create(:group, users: [user]) }
  let(:collection) { create(:collection, :visible) }

  background do
    switch_to_subdomain(group.subdomain)
    sign_in(user.email, "123456")
  end

  context "when I'm group owner", js: true do
    background do
      user.membership_for(group).owner!
      group.collections << collection
      visit edit_admin_group_path
    end

    scenario "I can edit a collection" do
      within(".collection[data-id='#{collection.id}']") do
        click_link "edit"
      end

      fill_in "Name", with: "New name"
      click_button "Save"

      expect(page).to have_content("Group")
      expect(current_path).to eq(edit_admin_group_path)
      expect(collection.reload.name).to eq("New name")

      within(".collection[data-id='#{collection.id}']") do
        expect(page).to have_content("NEW NAME")
      end
    end
  end
end
