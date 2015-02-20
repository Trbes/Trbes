require "rails_helper"

feature "List collections" do
  let(:user) { create(:user, :confirmed) }
  let(:group) { create(:group, users: [user]) }
  let(:collection) { create(:collection, :visible) }
  let(:another_collection) { create(:collection, :visible) }

  background do
    switch_to_subdomain(group.subdomain)
    sign_in(user.email, "123456")
  end

  context "when I'm group owner", js: true do
    background do
      user.membership_for(group).owner!
      group.collections << collection
      group.collections << another_collection
      visit edit_admin_group_path
    end

    scenario "I can view a list of collections" do
      expect(page).to have_css(".collection[data-id='#{collection.id}']")
      expect(page).to have_css(".collection[data-id='#{another_collection.id}']")
    end
  end
end
