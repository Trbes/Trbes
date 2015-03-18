require "rails_helper"

feature "List group members" do
  let(:user) { create(:user, :confirmed) }
  let(:group) { create(:group, users: [user]) }
  let!(:memberships) { create_list(:membership, 5, role: :member, group: group) }
  let(:membership) { memberships.first }

  background do
    user.membership_for(group).owner!
    switch_to_subdomain(group.subdomain)
    sign_in(user.email, "123456")
    visit admin_memberships_path
  end

  scenario "I can see list of group members" do
    expect(page).to have_css(".membership", count: memberships.count + 1)

    memberships.each do |membership|
      within("#membership_#{membership.id}") do
        expect(page).to have_content(membership.full_name)
        expect(page).to have_content(membership.role)
        expect(page).to have_link("remove from group")
      end
    end
  end

  scenario "I can remove member from group" do
    within("#membership_#{memberships.first.id}") do
      expect {
        click_link("remove from group")
      }.to change { Membership.count }.by(-1)
    end
  end

  scenario "I can change member role within members list", js: true do
    within("#membership_#{membership.id}") do
      bip_select(membership, "role", "moderator")

      expect(page).to have_content("moderator")
      expect(membership.reload.role).to eq("moderator")
    end
  end

  scenario "I can transfer ownership", js: true do
    click_link("owner")

    select(membership.full_name, from: "membership_new_group_owner_id")

    click_button "Save"

    expect(page).to have_content("Group")
    expect(user.membership_for(group).reload.role).to eq("moderator")
    expect(group.owner).to eq(membership)
  end
end
