require "rails_helper"

shared_examples_for "fresh social sign in" do
  scenario "successful sign in" do
    visit new_user_session_path

    expect {
      click_link social_link
    }.to change { User.count }.from(0).to(1)

    expect(page).to have_content("Sign out")
  end
end

shared_examples_for "social sign in for existing user" do
  scenario "successful sign in" do

  end
end


feature "Sign in" do
  context "with Twitter" do
    let(:social_link) { "Twitter" }

    context "when user is completely new" do
      it_behaves_like "fresh social sign in"
    end

    context "when email is found in base" do
      # it_behaves_like "social sign in for existing user"
    end
  end

  context "with Facebook" do
    let(:social_link) { "Facebook" }

    context "when user is completely new" do
      it_behaves_like "fresh social sign in"
    end

    context "when email is found in base" do
      # it_behaves_like "social sign in for existing user"
    end
  end

  context "with Google" do
    let(:social_link) { "Google" }

    context "when user is completely new" do
      it_behaves_like "fresh social sign in"
    end

    context "when email is found in base" do
      # it_behaves_like "social sign in for existing user"
    end
  end

  context "with LinkedIn" do
    let(:social_link) { "LinkedIn" }

    context "when user is completely new" do
      it_behaves_like "fresh social sign in"
    end

    context "when email is found in base" do
      # it_behaves_like "social sign in for existing user"
    end
  end
end
