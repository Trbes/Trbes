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
        expect(page).to have_content(membership.user_full_name)
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
end
