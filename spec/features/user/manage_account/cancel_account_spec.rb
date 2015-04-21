require "rails_helper"

feature "Cancel account" do
  include_context "group membership and authentication"

  scenario "I cancel my account", js: true do
    visit edit_user_registration_path(user)
    click_link "Cancel my account"

    expect(page).to have_content("Sign In")
    expect(page).to have_content("Bye! Your account was successfully cancelled. We hope to see you again soon.")

    visit new_user_session_path
    sign_in(user.email, "12345678")

    expect(page).to have_content("Invalid email or password.")
  end
end
