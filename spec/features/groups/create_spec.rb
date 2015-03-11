require "rails_helper"

feature "Create group" do
  let(:user) { create(:user) }
  let(:group_attributes) { attributes_for(:group) }
  let(:group) { Group.first }

  background do
    sign_in(user.email, "123456")
    visit root_path

    click_link "Create a Group"

    fill_in "Group Name", with: group_attributes[:name]
    fill_in "Short Name", with: group_attributes[:subdomain]
    fill_in "Tagline", with: group_attributes[:tagline]
    fill_in "Description", with: group_attributes[:description]
  end

  after(:each) do
    switch_to_main
  end

  scenario "User creates group successfully" do
    click_button "Create Trbes Group"

    expect(page).to have_content("Welcome to #{group.name}")

    expect(current_path).to eq(root_path)
    expect(current_url).to include(group.subdomain)

    expect(group).to be_persisted
    expect(group.users).to include(user)

    expect(user.membership_for(group)).to be_owner
  end
end
