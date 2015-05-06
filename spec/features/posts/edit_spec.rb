require "rails_helper"

shared_examples_for "editable posts" do
  scenario "I can see 'edit' link on posts list page", js: true do
    visit root_path

    within("#post_#{post.id}", visible: false) do
      expect(page).to have_css(".post-edit", text: "Edit", visible: false)
    end
  end

  scenario "I can see 'edit' link on single post page" do
    visit post_path(post)

    expect(page).to have_link("Edit")
  end

  scenario "I can edit post right in the page", js: true do
    visit post_path(post)

    click_link "Edit"

    expect(page).to have_css("#edit_post_#{post.id}.modal")

    fill_in "Title", with: "Some new title"

    click_button "Save"

    expect(page).to have_content("Some new title")
    expect(page).to have_content("was successfully updated")
  end
end

feature "Edit" do
  include_context "group membership and authentication"

  let(:post) { create(:post, group: group) }

  context "when post is available for edit" do
    before do
      post.update_attribute(:created_at, 1.minute.ago)
    end

    it_behaves_like "editable posts"
  end

  context "when post is not available for edit" do
    before do
      post.update_attribute(:created_at, 20.minutes.ago)
    end

    context "when I'm group member" do
      scenario "I can't see 'edit' link on posts list page", js: true do
        visit root_path

        within("#post_#{post.id}", visible: false) do
          expect(page).not_to have_link("Edit")
        end
      end

      scenario "I can't see 'edit' link on single post page" do
        visit post_path(post)

        expect(page).not_to have_link("Edit")
      end
    end

    context "when I'm group moderator" do
      background do
        membership.moderator!
      end

      it_behaves_like "editable posts"
    end

    context "when I'm group owner" do
      background do
        membership.owner!
      end

      it_behaves_like "editable posts"
    end
  end
end
