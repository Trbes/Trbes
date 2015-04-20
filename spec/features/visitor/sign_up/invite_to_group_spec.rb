require "rails_helper"

feature "Invite to group" do
  include_context "group membership and authentication"

  context "Non-owner" do
    scenario "User goes to invite page" do
      visit new_invitation_path

      expect(page.current_path).to eql root_path
    end
  end

  context "Owner", job: true do
    before(:each) do
      membership.owner!

      visit new_invitation_path
    end

    scenario "User goes to invite page" do
      expect(page.current_path).to eql new_invitation_path
    end

    scenario "User invites another user", js: true do
      find("#fiv_emails_tag").set("user1@example.com")
      click_button "Send Invitation"

      # Should show success popup.
      # This also waits for the ajax request to complete,
      # Which makes the tests that follow pass
      expect(page).to have_selector("#modal_invitation_success", visible: true)

      # Should stay on the page after sending invitation
      expect(page.current_path).to eql new_invitation_path
      expect(User.count).to eql 2

      # Close popup should reset the emails
      click_button "OK, I got it."
      expect(page).to have_selector("#modal_invitation_success", visible: false)
      expect(find("#fiv_emails", visible: false).value).to eql ""

      # Test the flow once again
      find("#fiv_emails_tag").set("user2@example.com")
      click_button "Send Invitation"
      wait_for_ajax
      expect(page.current_path).to eql new_invitation_path
      expect(User.count).to eql 3
    end

    scenario "User invites multiple users", js: true do
      expect {
        page.execute_script("$('#fiv_emails').val('user1@example.com,user2@example.com')")
        click_button "Send Invitation"

        expect(page).to have_selector("#modal_invitation_success", visible: true)
      }.to change { User.count }.by(2)
    end

    scenario "User enters invalid emails", js: true do
      expect {
        find("#fiv_emails_tag").set("user1@example., @example.com, some name")
        click_button "Send Invitation"
        wait_for_ajax
      }.not_to change { User.count }
    end
  end

  context "Invited", job: true do
    let(:invited_user_attributes) { attributes_for(:user, email: "invited@example.com") }

    before(:each) do
      membership.owner!
      visit new_invitation_path
      find("#fiv_emails").set(invited_user_attributes[:email])
      click_button "Send Invitation"

      # Clear cookies to sign-out current user (to do invited user tests)
      clear_cookies
    end

    scenario "User confirms invitation" do
      open_email(invited_user_attributes[:email])
      click_first_link_in_email

      email_field = page.find("#su_email")
      expect(email_field.value).to eql invited_user_attributes[:email]
      expect(email_field["disabled"]).to eql "disabled"

      fill_in "Full Name", with: invited_user_attributes[:full_name]
      fill_in "More About You (optional)", with: invited_user_attributes[:title]
      fill_in "Password", with: invited_user_attributes[:password]
      click_button "Create my account"

      expect(URI.parse(page.current_url).host.match(/([^\.]*)\..*$/)[1]).to eql group.subdomain
      expect(page.current_path).to eql root_path

      invited_user = User.find_by(email: invited_user_attributes[:email])
      membership = group.memberships.find_by(user_id: invited_user.id)
      expect(membership.member?).to be true
    end
  end
end
