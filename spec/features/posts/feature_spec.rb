require "rails_helper"

shared_examples_for "accessible featuring" do
  background do
    membership.update_attributes(role: role)
    visit root_path
  end

  scenario "can feature" do
    within("#post_#{unfeatured_post.id}") do
      expect(page).to have_css(".fa-star-o")
      expect(unfeatured_post).not_to be_featured
      page.find(".feature").click
      expect(page).to have_css(".fa-star")
      expect(unfeatured_post.reload).to be_featured
    end
  end

  scenario "can unfeature" do
    within("#post_#{featured_post.id}") do
      expect(page).to have_css(".fa-star")
      expect(featured_post).to be_featured
      page.find(".feature").click
      expect(page).to have_css(".fa-star-o")
      expect(featured_post.reload).not_to be_featured
    end
  end
end

shared_examples_for "inaccessible featuring" do
  background do
    membership.update_attributes(role: role)
    visit root_path
  end

  scenario "can't feature" do
    within("#post_#{unfeatured_post.id}") do
      expect(page).not_to have_css(".feature")
    end
  end

  scenario "can't unfeature" do
    within("#post_#{featured_post.id}") do
      expect(page).not_to have_css(".unfeature")
    end
  end
end

feature "feature comment", js: true do
  include_context "group membership and authentication"

  let!(:featured_post) { create(:post, group: group, membership: membership, featured: true) }
  let!(:unfeatured_post) { create(:post, group: group, membership: membership, featured: false) }

  context "When I'm owner" do
    it_behaves_like "accessible featuring" do
      let(:role) { :owner }
    end
  end

  context "When I'm moderator" do
    it_behaves_like "accessible featuring" do
      let(:role) { :moderator }
    end
  end

  context "When I'm member" do
    it_behaves_like "inaccessible featuring" do
      let(:role) { :member }
    end
  end

  context "When I'm pending member" do
    it_behaves_like "inaccessible featuring" do
      let(:role) { :pending }
    end
  end
end
