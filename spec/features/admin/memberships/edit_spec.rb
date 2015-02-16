require "rails_helper"

feature "Edit memberships" do
  let(:owner) { create(:user, :confirmed) }
  let(:moderator) { create(:user, :confirmed) }
  let(:member) { create(:user, :confirmed) }
  let(:group) { create(:group, users: [owner, moderator, member]) }

  background do
    moderator.membership_for(group).moderator!
    switch_to_subdomain(group.subdomain)
    sign_in(owner.email, "123456")
  end

  context "when I'm group owner" do
    background do
      owner.membership_for(group).owner!
      visit edit_admin_group_path
    end

    scenario "I can transfer ownership", js: true do
      click_link("transfer")

      select(moderator.full_name, from: "membership_new_group_owner_id")

      click_button "Save"

      expect(page).to have_content("Group")
      expect(owner.membership_for(group).reload.role).to eq("moderator")
      expect(group.owner).to eq(moderator.membership_for(group))
    end

    scenario "I can assign moderators", js: true do
      click_link("add moderator")

      select(member.full_name, from: "moderator_id")

      click_button "Save"

      expect(page).to have_content("Group")
      expect(group.moderators).to include(moderator.membership_for(group))
    end

    scenario "I can remove moderator rights" do
      within("#membership_#{moderator.membership_for(group).id}") do
        click_link("[x]")
      end

      expect(page).to have_content("Group")
      expect(group.moderators).to be_empty
    end
  end

  context "when I'm moderator" do
    background do
      owner.membership_for(group).moderator!
      visit edit_admin_group_path
    end

    scenario "I can't transfer ownership" do
      expect(page).to_not have_link("transfer")
    end

    scenario "I can't assign moderators" do
      expect(page).to_not have_link("add moderator")
    end

    scenario "I can't remove moderator rights" do
      within("#membership_#{moderator.membership_for(group).id}") do
        expect(page).to_not have_link("[x]")
      end
    end
  end
end
