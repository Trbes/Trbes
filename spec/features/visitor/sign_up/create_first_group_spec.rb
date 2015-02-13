require "rails_helper"

feature "Create first group" do
  let(:user) { create(:user) }
  let(:group_attributes) { attributes_for(:group) }
  let(:group) { Group.first }

  context "Unauthorized" do
    scenario "Unauthorized user tries to create group" do
      visit welcome_path
      expect(page.current_path).to eql root_path
    end
  end

  context "Authorized" do
    before(:each) do
      sign_in(user.email, "123456")
      visit welcome_path

      fill_in "Group Name (Your group or company full name)", with: group_attributes[:name]
      fill_in "Short Name (Alphabetical. Max 20 chars", with: group_attributes[:subdomain]
      fill_in "Description or Tagline (Will be shown under your group name)", with: group_attributes[:description]
    end

    after(:each) do
      switch_to_main
    end

    scenario "User create first group successfully" do
      click_button "Create Trbes Group"

      # Redirect to group invite url
      expect(page.current_path).to eql invite_path
      expect(URI.parse(page.current_url).host.match(/([^\.]*)\..*$/)[1]).to eql group.subdomain

      # Group is created
      expect(group).to be_persisted
      expect(group.users).to include(user)

      # User is added as owner
      membership = group.memberships.find_by(user: user)
      expect(membership.owner?).to be true
    end

    scenario "User set Intended Usage as Knowledge Base" do
      find("#cg_intended_usage label:first-child input[name='group[intended_usage]']").set(true)

      click_button "Create Trbes Group"

      expect(group.allow_text_posts).to be true
      expect(group.allow_link_posts).to be true
      expect(group.allow_image_posts).to_not be true
    end

    scenario "User set Intended Usage as Collection of Links" do
      find("#cg_intended_usage label:last-child input[name='group[intended_usage]']").set(true)

      click_button "Create Trbes Group"

      expect(group.allow_text_posts).to_not be true
      expect(group.allow_link_posts).to be true
      expect(group.allow_image_posts).to_not be true
    end

    scenario "User check Accept Image-Only posts" do
      find("input[name='group[allow_image_posts]']").set(true)

      click_button "Create Trbes Group"

      expect(group.allow_image_posts).to be true
    end
  end
end
