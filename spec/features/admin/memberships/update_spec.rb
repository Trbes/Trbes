require "rails_helper"

feature "Update membership" do
  include_context "group membership and authentication"

  let!(:memberships) { create_list(:membership, 5, role: :member, group: group) }
  let(:some_membership) { memberships.first }

  background do
    membership.owner!
    visit admin_memberships_path
  end

  scenario "I can change member role within members list", js: true do
    find("section.memberships #membership_#{some_membership.id} .role-link").click

    within("ul.select2-results") do
      find("li div", text: /\Amoderator\z/).click
    end

    wait_for_ajax

    within("section.memberships #membership_#{some_membership.id}") do
      expect(page).to have_content("moderator")
      expect(some_membership.reload.role).to eq("moderator")
    end

    open_email(some_membership.email)

    expect(current_email).to have_subject "Your role in #{group.name} has changed"
  end

  scenario "I can transfer ownership", js: true do
    click_link("owner")

    select(some_membership.full_name, from: "membership_new_group_owner_id")

    click_button "Save"

    expect(page).to have_content("Group")
    expect(user.membership_for(group).reload.role).to eq("moderator")
    expect(group.owner).to eq(some_membership)
  end
end
