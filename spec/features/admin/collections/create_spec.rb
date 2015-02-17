require "rails_helper"

feature "Create collection" do
  let(:user) { create(:user, :confirmed) }
  let(:group) { create(:group, users: [user]) }

  background do
    switch_to_subdomain(group.subdomain)
    sign_in(user.email, "123456")
  end

  context "when I'm group owner" do
    background do
      user.membership_for(group).owner!
      visit new_admin_collection_path
    end

    scenario "I can create a collection" do
      fill_in "Name", with: "Name"
      attach_file "Image", "spec/support/trbes.png"

      expect {
        click_button "Save"
      }.to change { Collection.count }.from(0).to(1)

      expect(current_path).to eq(admin_collection_path(Collection.last))
    end
  end

  context "when I'm not group owner" do
    background do
      visit new_admin_collection_path
    end

    scenario "I can't create a collection" do
      expect(page).to have_content("You are not authorized to perform this action.")
    end
  end
end
