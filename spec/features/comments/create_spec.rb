require "rails_helper"

feature "Post a comment" do
  let(:user) { create(:user, :confirmed) }
  let(:group) { create(:group) }
  let!(:post) { create(:post, :text, group: group) }

  background do
    switch_to_subdomain(group.subdomain)
    group.users << user
    sign_in(user.email, "123456")
    visit post_path(post)
  end

  after { switch_to_main }

  scenario "I post a comment under post" do
    expect {
      within "#new_comment" do
        fill_in "comment[body]", with: "Comment body"
        click_button "Submit"
      end
    }.to change { post.comments.count }.from(0).to(1)

    comment = post.comments.last

    within "#comment_#{comment.id}" do
      expect(page).to have_content("Comment body")
      expect(page).to have_content(user.full_name)
    end
  end

  context "when there are existing comments" do
    let!(:comment) { create(:comment, post: post, user: user) }

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
end
