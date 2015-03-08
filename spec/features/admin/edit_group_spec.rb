require "rails_helper"

feature "Admin group page" do
  let(:user) { create(:user, :confirmed) }
  let(:group) { create(:group, users: [user]) }

  background do
    switch_to_subdomain(group.subdomain)
    sign_in(user.email, "123456")
  end

  context "when I'm group admin" do
    background do
      user.membership_for(group).owner!
      visit root_path
    end

  end
end
