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
      within("section.memberships #membership_#{membership.id}") do
        expect(page).to have_content(membership.full_name)
        expect(page).to have_content(membership.role)
        expect(page).to have_link("remove from group")
      end
    end
  end

  context "when there are different membership types" do
    let(:moderator) { memberships.first }
    let(:pending) { memberships.last }

    background do
      moderator.moderator!
      pending.pending!
      visit admin_memberships_path
    end

    scenario "I can filter members by their membership type", js: true do
      select "Moderator", from: "[filter]"

      within("section.memberships") do
        expect(page).to have_css("#membership_#{moderator.id}")
        expect(page).not_to have_css("#membership_#{pending.id}")
      end

      select "Pending", from: "[filter]"

      within("section.memberships") do
        expect(page).to have_css("#membership_#{pending.id}")
        expect(page).not_to have_css("#membership_#{moderator.id}")
      end
    end
  end

  scenario "I can remove member from group" do
    within("section.memberships #membership_#{memberships.first.id}") do
      expect {
        click_link("remove from group")
      }.to change { Membership.count }.by(-1)
    end
  end

  scenario "I can change member role within members list", js: true do
    find("section.memberships #membership_#{membership.id} .role-link").click

    within("ul.select2-results") do
      find("li div", text: /\Amoderator\z/).click
    end

    wait_for_ajax

    within("section.memberships #membership_#{membership.id}") do
      expect(page).to have_content("moderator")
      expect(membership.reload.role).to eq("moderator")
    end

    open_email(membership.email)

    expect(current_email).to have_subject "Your role in #{group.name} has changed"
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
