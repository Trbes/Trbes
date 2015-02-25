require "rails_helper"

feature "Join group" do
  let!(:group) { create(:group) }
  let(:user) { create(:user) }

  context "when I'm unconfirmed group member" do
    background do
      group.add_member(user, as: :pending)
      sign_in(user.email, "123456")
      visit "/explore"
    end

    scenario "I see notice about my request" do
      within("#group_#{group.id}") do
        expect(page).to have_content("Join request was sent")
      end
    end
  end

  context "when I'm not-signed-in visitor" do
    background do
      visit "/explore"
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
      group.add_member(user, as: :member)
      sign_in(user.email, "123456")
      visit "/explore"
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
      sign_in(user.email, "123456")
      visit "/explore"
    end

    scenario "I can request membership" do
      within("#group_#{group.id}") do
        click_button "Join"
      end

      expect(current_path).to eq("/explore")

      within("#group_#{group.id}") do
        expect(page).to have_content("Join request was sent")
      end

      expect(group.memberships).to include(user.membership_for(group))
      expect(user.membership_for(group).role).to eq("pending")
    end
  end
end
