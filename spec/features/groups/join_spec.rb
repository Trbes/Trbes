require "rails_helper"

feature "Join group" do
  let!(:membership) { create(:membership) }
  let!(:user) { membership.user }
  let!(:group) { membership.group }

  background do
    sign_in(user.email, "123456")
  end

  context "when I'm unconfirmed group member" do
    background do
      membership.pending!
      visit "/"
    end

    scenario "I see notice about my request" do
      binding.pry
      within("#group_#{group.id}") do
        expect(page).to have_content("Join request was sent")
      end
    end
  end

  context "when I'm not-signed-in visitor" do
    background do
      sign_out
      visit "/"
    end

    scenario "I can request membership by signing in" do
      within("#group_#{group.id}") do
        click_link "Join"
      end

      expect(current_path).to eq(new_user_registration_path)
    end
  end

  context "When I'm confirmed group member" do
    background do
      membership.member!
      visit "/"
    end

    scenario "I can enter group" do
      within("#group_#{group.id}") do
        click_link "Enter"
      end

      expect(current_path).to eq(root_path)
      expect(current_url).to include(group.subdomain)
    end
  end

  context "When I'm signed in but not a group member" do
    background do
      membership.destroy
      visit "/"
    end

    scenario "I can request membership" do
      within("#group_#{group.id}") do
        click_link "Join"
      end

      expect(current_path).to eq("/")

      expect(page).to have_content(group.name)

      expect(group.memberships).to include(user.membership_for(group))
      expect(membership.role).to eq("pending")
    end
  end
end
