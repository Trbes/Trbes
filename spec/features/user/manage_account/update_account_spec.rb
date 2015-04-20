require "rails_helper"

feature "Update account with valid data" do
  include_context "group membership and authentication"

  background do
    visit edit_user_registration_path(user)
  end

  scenario "I submit update account form with valid data" do
    fill_form(:user,
      full_name: "New Name",
      current_password: "12345678"
    )

    click_button "Update"

    expect(current_path).to eq(edit_user_registration_path)
    expect(page).to have_content("New Name")
  end

  scenario "Wrong current password" do
    fill_form(:user,
      password: "new password",
      current_password: "wrong"
    )

    click_button "Update"

    expect(page).to have_content("is invalid")
  end
end
