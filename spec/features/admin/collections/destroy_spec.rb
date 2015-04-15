require "rails_helper"

feature "Destroy collection" do
  let(:user) { create(:user, :confirmed) }
  let(:group) { create(:group, users: [user]) }
  let(:collection) { create(:collection, :visible) }

  background do
    switch_to_subdomain(group.subdomain)
    sign_in(user.email, "123456")
  end

  context "when I'm group owner", js: true do
    background do
      user.membership_for(group).owner!
      group.collections << collection
      visit edit_admin_group_path
    end

    scenario "I can destroy a collection" do
      within(".collection[data-id='#{collection.id}']") do
        click_link "delete"
      end

      expect(page).to have_content("Group")
      expect(page).to have_content(%(Collection "#{collection.name}" has been deleted))
      expect(current_path).to eq(edit_admin_group_path)
      expect(page).not_to have_css(".collection[data-id='#{collection.id}']")
      expect(Collection.count).to eq(0)
    end
  end
end
