require "rails_helper"

feature "Invite to group" do
  let(:user) { create(:user) }
  let(:group) { create(:group) }

  context "Non-owner" do
    after do
      switch_to_main
    end

    scenario "User goes to invite page" do
      switch_to_subdomain(group.subdomain)
      sign_in(user.email, "123456")
      visit new_invitation_path

      expect(page.current_path).to eql root_path
    end
  end

  context "Owner", job: true do
    before(:each) do
      group.add_member(user, as: :owner)
      switch_to_subdomain(group.subdomain)
      sign_in(user.email, "123456")
      visit new_invitation_path
    end

    after(:each) do
      switch_to_main
    end

    scenario "User goes to invite page" do
      expect(page.current_path).to eql new_invitation_path
    end

    scenario "User invites another user" do
      expect {
        find("#fiv_emails").set("user1@example.com")
        click_button "Send Invitation"
      }.to change { User.count }.by(1)
    end

    scenario "User invites multiple users" do
      expect {
        find("#fiv_emails").set("user1@example.com,user2@example.com")
        click_button "Send Invitation"
      }.to change { User.count }.by(2)
    end

    scenario "User enters invalid emails" do
      expect {
        find("#fiv_emails").set("user1@example.,@example.com")
        click_button "Send Invitation"
      }.to_not change { User.count }
    end
  end

  context "Invited", job: true do
    let(:invited_user_attributes) { attributes_for(:user, email: "invited@example.com") }

    before(:each) do
      group.add_member(user, as: :owner)
      switch_to_subdomain(group.subdomain)
      sign_in(user.email, "123456")
      visit new_invitation_path
      find("#fiv_emails").set(invited_user_attributes[:email])
      click_button "Send Invitation"

      # Clear cookies to sign-out current user (to do invited user tests)
      clear_cookies
    end

    after do
      switch_to_main
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
      expect(membership.role?(:moderator)).to be true
    end
  end
end
