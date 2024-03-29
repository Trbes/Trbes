require "rails_helper"

feature "Create post", js: true do
  include_context "group membership and authentication"

  context "when I'm owner on admin page" do
    background do
      user.membership_for(group).owner!
      visit admin_dashboard_index_path
    end

    context "with valid data" do
      scenario "I post to group" do
        create_post(:link)

        expect(user.posts.last.state).to eq("published")
      end
    end
  end
end
