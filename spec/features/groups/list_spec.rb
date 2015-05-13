require "rails_helper"

feature "Groups list", js: true do
  let!(:group) { create(:group) }
  let!(:post) { create(:post, group: group) }
  let(:posts_count) { 5 }
  let(:extra_groups_count) { 10 }

  background do
    create(:membership, group: group, role: :owner)
    create_list(:post, posts_count, :text, group: group)
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
      create_list(:group, extra_groups_count, :with_owner)
      visit "/"
    end

    scenario "pagination happens" do
      expect(page).to have_css(".group", count: extra_groups_count)

      within(".pagination") do
        click_link "Next"
      end

      expect(page).to have_css(".group", count: 1)
    end
  end

  context "when there are private groups" do
    let!(:private_group) { create(:group, private: true) }

    scenario "I can't wee them within groups list" do
      visit root_path

      within("#group_#{group.id}") do
        expect(page).to have_css(".group-name", text: group.name)
      end

      expect(page).not_to have_css("#group_#{private_group.id}")
    end
  end
end
