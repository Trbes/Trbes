require "rails_helper"

feature "Group main page" do
  include_context "group membership and authentication"

  context "when my join request is not approved yet" do
    background do
      membership.pending!
      visit root_path
    end

    scenario "I see the pending membership notice" do
      expect(page).to have_content("Request to join group pending approval")

      membership.member!

      visit root_path

      expect(page).not_to have_content("Request to join group pending approval")
    end

    scenario "I can cancel my membership request", js: true do
      within(".alert-info") do
        click_link "Cancel"
      end

      expect(page).not_to have_content("Request to join group pending approval")
      expect(page).to have_content("Your membership request has been cancelled")
      expect(page).to have_css("#btn_join_group", text: "Join")
    end
  end

  context "when I try to reach private group by it's URL" do
    background do
      group.update_attributes(private: true)
      membership.pending!
    end

    scenario "I'm not allowed to do so" do
      visit root_path

      within(".navbar .group-name") do
        expect(page).not_to have_content(group.name)
      end
    end
  end
end

feature "Going to www subdomain" do
  background do
    switch_to_subdomain("www")
    visit root_path
  end

  after { switch_to_main }

  scenario "I will see home page instead of a group page" do
    expect(page).to have_content("Discover Interesting Teams")
  end
end
