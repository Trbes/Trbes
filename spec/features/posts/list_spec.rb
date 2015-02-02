require "rails_helper"

feature "Posts list" do
  let(:user) { create(:user, :confirmed) }
  let(:group) { create(:group) }
  let!(:post) { create(:post, :text, group: group) }

  before(:each) do
    sign_in(user.email, "123456")
    visit root_url(subdomain: group.subdomain)
  end

  scenario "I visit posts page" do
    within("#post_#{post.id}") do
      expect(page).to have_css(".title", text: post.title)
      expect(page).to have_css(".excerpt", text: post.body)
      expect(page.find(".post-thumb img")["src"]).to have_content(post.preview_image.url)
    end
  end
end
