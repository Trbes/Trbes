require "rails_helper"

feature "Update account with valid data" do
  include_context "group membership and authentication"

  background do
    visit edit_user_registration_path(user)
  end

  scenario "I submit update account form with valid data" do
    expect(user.avatar.filename).not_to be

    fill_form(:user,
      full_name: "New Name",
      current_password: "12345678"
    )

    attach_file "Avatar", "spec/support/trbes.png"

    click_button "Update"

    expect(current_path).to eq(edit_user_registration_path)
    expect(page).to have_content("New Name")
    expect(user.reload.avatar.filename).to be
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
