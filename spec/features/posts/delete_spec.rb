require "rails_helper"

shared_examples_for "deletable post" do
  scenario "I can delete post from posts list page" do
    visit root_path

    within("#post_#{post.id}") do
      expect(page).to have_link("Delete")

      expect {
        click_link("Delete")
      }.to change { Post.count }.from(1).to(0)
    end
  end

  scenario "I can delete post from post page" do
    visit post_path(post)

    expect(page).to have_link("Delete")

    expect {
      click_link("Delete")
    }.to change { Post.count }.from(1).to(0)
  end
end

shared_examples_for "not deletable post" do
  scenario "I can delete post from posts list page" do
    visit root_path

    within("#post_#{post.id}") do
      expect(page).not_to have_link("Delete")
    end
  end

  scenario "I can delete post from post page" do
    visit post_path(post)

    expect(page).not_to have_link("Delete")
  end
end

feature "Delete post" do
  include_context "group membership and authentication"

  let!(:post) { create(:post, group: group) }

  context "when I'm owner" do
    background do
      membership.owner!
    end

    it_behaves_like "deletable post"
  end

  context "when I'm moderator" do
    background do
      membership.moderator!
    end

    it_behaves_like "deletable post"
  end

  context "when I'm member" do
    background do
      membership.member!
    end

    context "when I'm not post author" do
      background do
        post.update_attributes(membership: nil)
      end

      it_behaves_like "not deletable post"
    end

    context "when I'm post author" do
      background do
        post.update_attributes(membership: membership)
      end

      it_behaves_like "deletable post"
    end
  end

  context "when I'm pending member" do
    background do
      membership.pending!
    end

    it_behaves_like "not deletable post"
  end

  context "when I'm guest" do
    background do
      click_link "Sign out"
    end

    it_behaves_like "not deletable post"
  end
end
