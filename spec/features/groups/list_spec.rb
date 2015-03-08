require "rails_helper"

feature "Groups list" do
  let!(:group) { create(:group) }
  let!(:post) { create(:post, :text, group: group) }

  background do
    create_list(:post, 20, :text, group: group)
    visit "/"
  end

  scenario "I visit explore page" do
    within("#group_#{group.id}") do
      expect(page).to have_css(".group-name", text: group.name)
      expect(page).to have_css(".group-tagline", text: group.tagline)
      expect(page).to have_css(".group-desc", text: group.description)
      expect(page).to have_link "Join"
    end
  end

  context "when there are too many groups" do
    background do
      create_list(:group, 20)
      visit "/"
    end

    scenario "pagination happens" do
      expect(page).to have_css(".group", count: 20)

      within(".pagination") do
        click_link "Next"
      end

      expect(page).to have_css(".group", count: 1)
    end
  end
end
