require "rails_helper"

feature "Edit group", js: true do
  include_context "group membership and authentication"

  background do
    membership.owner!
    visit edit_admin_group_path
    click_link "edit"
  end

  scenario "Edit group" do
    fill_in "Name", with: "New Name"
    fill_in "Tagline", with: "New Tagline"
    fill_in "Description", with: "New Description"
    fill_in "Custom domain", with: "example.com"
    page.find("#cg_privacy").click

    click_button "Save"

    expect(current_path).to eq(edit_admin_group_path)
    group.reload

    expect(group.name).to eq("New Name")
    expect(group.tagline).to eq("New Tagline")
    expect(group.description).to eq("New Description")
    expect(group.private).to eq(true)
    expect(group.custom_domain).to eq("example.com")
  end

  context "when group is private" do
    background do
      group.update_attributes(private: true)
      visit edit_admin_group_path
      click_link "edit"
    end

    scenario "turn off privacy" do
      page.find("#cg_privacy").click
      click_button "Save"

      expect(current_path).to eq(edit_admin_group_path)
      group.reload

      expect(group.private).to eq(false)
    end
  end
end
