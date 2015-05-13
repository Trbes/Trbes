require "rails_helper"

feature "Delete a group" do
  include_context "group membership and authentication"

  background do
    membership.owner!
    visit edit_admin_group_path
  end

  scenario "Soft delete keeps the group but hides from default scope" do
    expect {
      click_link("delete")
    }.to change { Group.count }.from(1).to(0)

    expect(Group.deleted.first).to eq(group)
  end

  context "when logged in as moderator" do
    background do
      membership.moderator!
    end

    scenario "cannot delete group" do
      visit edit_admin_group_path

      within(".group-profile") do
        expect(page).not_to have_link("delete")
      end
    end
  end
end
