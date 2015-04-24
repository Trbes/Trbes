require "rails_helper"

shared_examples_for "visible notifications" do
  background do
    visit root_path
  end

  scenario "I can see notifications badge" do
    within(".group-info") do
      expect(page).to have_css(".notifications-count", text: objects.count)
    end
  end
end

shared_examples_for "not visible notifications" do
  background do
    visit root_path
  end

  scenario "I can see notifications badge" do
    within(".group-info") do
      expect(page).not_to have_css(".notifications-count")
    end
  end
end

feature "Admin notifications" do
  include_context "group membership and authentication"

  context "when I'm group admin" do
    background do
      membership.owner!
    end

    context "when there are pending posts" do
      let!(:objects) { create_list(:post, 2, state: :moderation, group: group) }

      it_behaves_like "visible notifications"
    end

    context "when there are pending comments" do
      let(:post) { create(:post, group: group ) }
      let!(:objects) { create_list(:comment, 2, state: :moderation, post: post) }

      it_behaves_like "visible notifications"
    end

    context "when there are pending members" do
      let!(:objects) { create_list(:membership, 2, role: :pending, group: group) }

      it_behaves_like "visible notifications"
    end
  end

  context "when I'm group member" do
    background do
      visit root_path
    end

    context "when there are pending posts" do
      let!(:objects) { create_list(:post, 2, state: :moderation, group: group) }

      it_behaves_like "not visible notifications"
    end

    context "when there are pending comments" do
      let(:post) { create(:post, group: group ) }
      let!(:objects) { create_list(:comment, 2, state: :moderation, post: post) }

      it_behaves_like "not visible notifications"
    end

    context "when there are pending members" do
      let!(:objects) { create_list(:membership, 2, role: :pending, group: group) }

      it_behaves_like "not visible notifications"
    end
  end
end
