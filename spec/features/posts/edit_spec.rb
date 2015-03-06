require "rails_helper"

feature "Edit post" do
  let(:user) { create(:user, :confirmed) }
  let(:group) { create(:group) }
  let(:post) { create(:post, :published, :text, group: group) }

  background do
    switch_to_subdomain(group.subdomain)
    sign_in(user.email, "123456")
    group.add_member(user, as: :member)
  end

  context "when post is available for edit" do
    before do
      post.update_attribute(:created_at, 1.minute.ago)
    end

    scenario "I can see 'edit' link on posts list page" do
      visit root_path

      within("#post_#{post.id}") do
        expect(page).to have_link("Edit")
      end
    end

    scenario "I can see 'edit' link on single post page" do
      visit post_path(post)

      expect(page).to have_link("Edit post")
    end

    scenario "I can visit 'edit' post page" do
      visit edit_post_path(post)

      expect(page).to have_css("form.edit_post")

      fill_in "Title", with: "Some new title"

      expect {
        click_button "Save"
      }.to change { post.reload.title }.to("Some new title")
    end
  end

  context "when post is not available for edit" do
    before do
      post.update_attribute(:created_at, 20.minutes.ago)
    end

    scenario "I can't see 'edit' link on posts list page" do
      visit root_path

      within("#post_#{post.id}") do
        expect(page).not_to have_link("Edit")
      end
    end

    scenario "I can't see 'edit' link on single post page" do
      visit post_path(post)

      expect(page).not_to have_link("Edit post")
    end

    scenario "I can't visit 'edit' post page" do
      visit edit_post_path(post)

      expect(page).to have_content("You are not authorized to perform this action.")
    end
  end
end
