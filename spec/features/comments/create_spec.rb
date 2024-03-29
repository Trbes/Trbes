require "rails_helper"

feature "Post a comment" do
  include_context "group membership and authentication"

  let!(:post) { create(:post, group: group) }

  background do
    visit post_path(post)
  end

  def create_comment(body: "Comment body")
    within "#new_comment" do
      fill_in "comment[body]", with: body
      click_button "Submit"
    end
  end

  context "with invalid body" do
    context "with ' ' body" do
      let(:body) { " " }

      scenario "I post a comment under post", js: true do
        create_comment(body: body)

        expect(page).to have_content("Body can't be blank")

        expect(post.comments).to be_empty
      end
    end

    context "with too short body" do
      let(:body) { "Abc" }

      scenario "I post a comment under post", js: true do
        create_comment(body: body)

        expect(page).to have_content("Body is too short (minimum is 5 characters)")

        expect(post.comments).to be_empty
      end
    end

    context "with too long body" do
      let(:body) { "A" * 500 }

      scenario "I post a comment under post", js: true do
        create_comment(body: body)

        expect(page).to have_content("Body is too long (maximum is 420 characters)")

        expect(post.comments).to be_empty
      end
    end
  end

  context "with valid body" do
    scenario "I post a comment under post", js: true do
      create_comment

      expect(page).to have_content(I18n.t("app.comment.message.success"))
      comment = post.comments.last

      within "#comment_#{comment.id}" do
        expect(page).to have_content("Comment body")
        expect(page).to have_content(user.full_name)
      end

      expect(post.comments.count).to eq(1)
    end

    context "when there are existing comments" do
      let!(:comment) { create(:comment, post: post, membership: membership) }

      background do
        visit post_path(post)
      end

      scenario "I post a nested comment", js: true do
        within "#comment_#{comment.id}" do
          click_link "reply"
        end

        within ".post-a-comment.nested" do
          fill_in "comment[body]", with: "Comment response"
          click_button "Submit"
        end

        expect(page).to have_content("Comment response")
        expect(comment.child_comments.first.body).to eq("Comment response")
      end
    end

    context "when I'm approved member" do
      background do
        membership.member!
        visit post_path(post)
      end

      scenario "I post a comment" do
        create_comment

        expect(post.comments.last.state).to eq("published")
      end
    end

    context "when I'm pending member" do
      background do
        membership.pending!
        visit post_path(post)
      end

      scenario "I post a comment" do
        create_comment

        expect(post.comments.last.state).to eq("moderation")
      end
    end
  end
end
