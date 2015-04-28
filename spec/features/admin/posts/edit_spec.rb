require "rails_helper"

feature "Edit post in admin panel", js: true do
  include_context "group membership and authentication"

  let!(:post) { create(:post, group: group) }

  context "when I'm owner on admin page" do
    background do
      membership.owner!

      visit admin_dashboard_index_path
    end

    scenario "I edit post" do
      edit_post(post, title: "New Title")

      expect(page).to have_content("New Title")
      expect(post.reload.title).to eq("New Title")
    end

    context "when post is deleted" do
      before do
        post.update(deleted_at: Date.today)
      end

      scenario "I edit post" do
        edit_post(post, title: "New Title")

        expect(page).to have_content("New Title")
        expect(post.reload.title).to eq("New Title")
      end
    end

    def edit_post(post, options = {})
      within("#post_#{post.id}") do
        click_link "edit"
      end

      fill_in "post[title]", with: options[:title]
      click_button "Save"
    end
  end
end
