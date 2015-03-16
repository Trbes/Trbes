require "rails_helper"

feature "Edit group" do
  let(:user) { create(:user) }
  let(:group) { create(:group, users: [user]) }

  background do
    switch_to_subdomain(group.subdomain)
    user.membership_for(group).owner!
    sign_in(user.email, "123456")
    visit edit_admin_group_path
    click_link "edit"
  end

  after(:each) do
    switch_to_main
  end

  scenario "Edit group", js: true do
    fill_in "Name", with: "New Name"
    fill_in "Tagline", with: "New Tagline"
    fill_in "Description", with: "New Description"
    page.find("label[for='group_private']").click

    click_button "Save"

    expect(current_path).to eq(edit_admin_group_path)
    group.reload

    expect(group.name).to eq("New Name")
    expect(group.tagline).to eq("New Tagline")
    expect(group.description).to eq("New Description")
    expect(group.private).to eq(true)
  end
end
