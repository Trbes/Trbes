require "rails_helper"

feature "Group main page" do
  include_context "group membership and authentication"

  context "when my join request is not approved yet" do
    background do
      membership.pending!
      visit root_path
    end

    scenario "I see the pending membership notice" do
      expect(page).to have_content("Request to join group pending approval.")

      membership.member!

      visit root_path

      expect(page).not_to have_content("Request to join group pending approval.")
    end
  end
end
