require "rails_helper"

feature "Sign up" do
  let(:user) { User.first }
  let(:user_attributes) { attributes_for(:user).slice(:email, :full_name, :title, :password) }

  context "from Trbes landing page" do
    before(:each) do
      visit new_user_registration_path

      fill_in "Email Address", with: user_attributes[:email]
      fill_in "Full Name", with: user_attributes[:full_name]
      fill_in "More About You (optional)", with: user_attributes[:title]
      fill_in "Password", with: user_attributes[:password]
      click_button "Create my account"
    end

    scenario "User signs up successfully" do
      expect(page.current_path).to eql welcome_path
      expect(page).to have_text("You are now subscribed to Trbes")
      open_email(user.email)

      expect(current_email).to have_subject "Trbes: Confirmation instructions"
      expect(current_email).to have_body_text(user.full_name)
    end

    scenario "User confirms account", job: true do
      open_email(user.email)
      visit_in_email "Confirm my account"

      expect(page).to have_text(user.full_name)
    end

    scenario "User resents email confirmation instructions" do
      visit new_user_confirmation_path

      fill_in "user_email", with: user.email
      click_button "Resend confirmation instructions"

      open_email(user.email)

      expect(current_email).to have_subject "Trbes: Confirmation instructions"
      expect(current_email).to have_body_text(user.full_name)
    end
  end

  context "from group page" do
    let(:group) { create(:group) }

    before(:each) do
      switch_to_subdomain(group.subdomain)
    end

    after(:each) do
      switch_to_main
    end

    scenario "User signs up via group page" do
      visit new_user_registration_path

      fill_in "Email Address", with: user_attributes[:email]
      fill_in "Full Name", with: user_attributes[:full_name]
      fill_in "More About You (optional)", with: user_attributes[:title]
      fill_in "Password", with: user_attributes[:password]
      click_button "Create my account"

      expect(page.current_path).to eql welcome_path
      expect(page).to have_text("You are now subscribed to " + group.name)
    end
  end
end
