require "rails_helper"

feature "Post a comment" do
  let(:user) { create(:user, :confirmed) }
  let(:group) { create(:group) }
  let!(:post) { create(:post, :text, group: group) }

  before(:each) do
    switch_to_subdomain(group.subdomain)
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
end
