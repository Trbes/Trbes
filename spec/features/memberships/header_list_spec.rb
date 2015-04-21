require "rails_helper"

feature "Memberships list within group header" do
  include_context "group membership and authentication"

  let(:not_confirmed_user) { create(:user, :not_confirmed) }

  context "when there are 5 valid memberships 1 pending and 1 not confirmed" do
    let!(:valid_memberships) { create_list(:membership, 4, group: group, role: :member) }
    let!(:pending_membership) { create(:membership, group: group, role: :pending, user: create(:user, :confirmed)) }

    background do
      visit "/"
    end

    scenario "I can see 5 valid memberships within memberships list" do
      valid_memberships.unshift(membership).each do |valid_membership|
        expect(page).to have_css("#membership_#{valid_membership.id}")
      end
    end

    scenario "I can't see any pending memberships" do
      expect(page).not_to have_css("#membership_#{pending_membership.id}")
    end

    scenario "I can't see 'more' link" do
      expect(page).not_to have_css(".more")
    end
  end

  context "when there are too much (6) valid memberships" do
    let!(:valid_memberships) { create_list(:membership, 5, group: group, role: :member) }
    let(:total_valid_memberships) { valid_memberships.unshift(membership) }

    background do
      visit "/"
    end

    scenario "I see first 5 memberships within memberships list" do
      total_valid_memberships.first(5).each do |valid_membership|
        expect(page).to have_css("#membership_#{valid_membership.id}")
      end
    end

    scenario "I can see 'more' link" do
      expect(page).to have_css(".more")
    end

    scenario "I can see list of all memberships after clicking on 'more' link", js: true do
      page.find(".more").click

      expect(page).to have_content("There are #{total_valid_memberships.count} members in #{group.name}")

      total_valid_memberships.each do |valid_membership|
        expect(page).to have_css("#membership_#{valid_membership.id}")
      end
    end
  end
end
