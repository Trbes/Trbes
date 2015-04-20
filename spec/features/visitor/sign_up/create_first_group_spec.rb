require "rails_helper"

feature "Create first group" do
  include_context "group membership and authentication"

  let(:group_attributes) { attributes_for(:group) }
  let(:created_group) { Group.last }

  context "Unauthorized" do
    background do
      click_link "Sign out"
    end

    scenario "Unauthorized user tries to create group" do
      visit welcome_path

      expect(page.current_path).to eql root_path
    end
  end

  context "Authorized" do
    background do
      group.destroy
      switch_to_main
      sign_in(user.email, "12345678")
    end

    scenario "User create first group successfully" do
      visit welcome_path

      fill_in "Group Name", with: group_attributes[:name]
      fill_in "Short Name", with: group_attributes[:subdomain]
      fill_in "Tagline", with: group_attributes[:tagline]
      fill_in "Description", with: group_attributes[:description]

      click_button "Create Trbes Group"

      # Redirect to group invite url
      expect(page.current_path).to eql new_invitation_path
      expect(current_url).to include(created_group.reload.subdomain)

      # Group is created
      expect(created_group).to be_persisted
      expect(created_group.users).to include(user)
      expect(created_group.allow_text_posts).to be_truthy
      expect(created_group.allow_link_posts).to be_truthy
      expect(created_group.allow_image_posts).to be_truthy

      # User is added as owner
      expect(user.membership_for(created_group)).to be_owner
    end
  end
end
