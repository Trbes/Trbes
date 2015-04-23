require "rails_helper"

feature "Create post", js: true do
  include_context "group membership and authentication"

  context "when I'm approved member" do
    background do
      visit root_path
    end

    context "with valid data" do
      scenario "I post to group" do
        create_post(:link)

        expect(user.posts.last.state).to eq("published")
      end
    end

    context "with invalid data" do
      context "no fields are filled" do
        scenario "I can't post to group" do
          page.find("#btn_add_post").click
          click_button "Publish Post"

          expect(page).to have_content("This field is required.")
        end
      end

      context "Title is too short" do
        scenario "I can't post to group" do
          page.find("#btn_add_post").click

          fill_in "Title", with: "word"
          click_button "Publish Post"

          expect(page).to have_content("Please enter at least 5 characters.")
        end
      end

      context "Body is blank for text post" do
        scenario "I can't post to group" do
          page.find("#btn_add_post").click
          page.find("#select_post_type").click
          page.find(".toggle-post-type", text: "Text").click

          fill_in "Title", with: "Long enough title"

          click_button "Publish Post"

          expect(page).to have_content("This field is required.")
        end
      end

      context "trying to add not allowed post type" do
        scenario "I can't post to group" do
          page.find("#btn_add_post").click
          page.find("#select_post_type").click
          page.find(".toggle-post-type", text: "Text").click

          fill_in "Title", with: "Long enough title"
          fill_in "Your Text", with: "Text"

          group.update_attributes(allow_text_posts: false)

          click_button "Publish Post"

          expect(page).to have_content("Post type is not included in the list")
          expect(user.posts).to be_empty
        end
      end
    end
  end

  context "when I'm pending member" do
    background do
      membership.pending!
      visit root_path
    end

    scenario "I post to group" do
      create_post(:link)

      expect(user.posts.last.state).to eq("moderation")
    end
  end
end
