require "rails_helper"

feature "Update membership", js: true do
  include_context "group membership and authentication"

  let!(:memberships) { create_list(:membership, 5, role: :member, group: group) }
  let(:some_membership) { memberships.first }

  background do
    membership.owner!
    visit admin_memberships_path
  end

  scenario "I can change member role within members list" do
    find("section.memberships #membership_#{some_membership.id} .role-link").click

    within("ul.select2-results") do
      find("li div", text: /\Amoderator\z/).click
    end

    wait_for_ajax

    within("section.memberships #membership_#{some_membership.id}") do
      expect(page).to have_content("moderator")
      expect(some_membership.reload.role).to eq("moderator")
    end

    open_email(some_membership.user_email)

    expect(current_email).to have_subject("Your role in #{group.name} has changed")
    expect(current_email.body.encoded).to include("http://#{group.subdomain}.#{DEFAULT_HOST}")
    expect(current_email.body).to include("Martin, Airat, Cody and the Trbes Team.")
  end

  context "when there are posts by this user in 'moderation' state" do
    background do
      some_membership.pending!
      create_list(:post, 3, membership: some_membership, group: group, state: :moderation)
      create_list(:comment, 3, membership: some_membership, post: group.posts.first, state: :moderation)

      visit admin_memberships_path
    end

    scenario "posts and comments are published after membership is confirmed" do
      some_membership.posts.each do |post|
        expect(post).to be_moderation
      end

      some_membership.comments.each do |comment|
        expect(comment).to be_moderation
      end

      find("section.memberships #membership_#{some_membership.id} .role-link").click

      within("ul.select2-results") do
        find("li div", text: /\Amember\z/).click
      end

      wait_for_ajax

      some_membership.posts.reload.each do |post|
        expect(post).to be_published
      end

      some_membership.comments.reload.each do |comment|
        expect(comment).to be_published
      end
    end
  end

  scenario "I can transfer ownership" do
    click_link("owner")

    select(some_membership.user_full_name, from: "membership_new_group_owner_id")

    click_button "Save"

    expect(page).to have_content("Group")
    expect(user.membership_for(group).reload.role).to eq("moderator")
    expect(group.owner).to eq(some_membership)
  end
end
