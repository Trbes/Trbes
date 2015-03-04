require "rails_helper"

shared_examples_for "accessible favouriting" do
  background do
    sign_in(user.email, "123456")
    group.add_member(user, as: role)
    visit post_path(post)
  end

  scenario "can favourite" do
    within("#comment_#{unfavourited_comment.id}") do
      expect(unfavourited_comment).not_to be_favourite
      page.find(".favourite").click
      expect(unfavourited_comment.reload).to be_favourite
    end
  end

  scenario "can unfavourite" do
    within("#comment_#{favourited_comment.id}") do
      expect(favourited_comment).to be_favourite
      page.find(".unfavourite").click
      expect(favourited_comment.reload).not_to be_favourite
    end
  end
end

shared_examples_for "inaccessible favouriting" do
  background do
    sign_in(user.email, "123456")
    group.add_member(user, as: role)
    visit post_path(post)
  end

  scenario "can't favourite" do
    within("#comment_#{unfavourited_comment.id}") do
      expect(page).not_to have_css(".favourite")
    end
  end

  scenario "can't unfavourite" do
    within("#comment_#{favourited_comment.id}") do
      expect(page).not_to have_css(".unfavourite")
    end
  end
end

feature "Favourite comment" do
  let(:user) { create(:user, :confirmed) }
  let(:group) { create(:group) }
  let(:post) { create(:post, :text, :published, group: group) }
  let!(:favourited_comment) { create(:comment, :published, post: post, user: user, favourite: true) }
  let!(:unfavourited_comment) { create(:comment, :published, post: post, user: user, favourite: false) }

  background do
    switch_to_subdomain(group.subdomain)
  end

  after { switch_to_main }

  context "When I'm owner" do
    it_behaves_like "accessible favouriting" do
      let(:role) { :owner }
    end
  end

  context "When I'm moderator" do
    it_behaves_like "accessible favouriting" do
      let(:role) { :moderator }
    end
  end

  context "When I'm member" do
    it_behaves_like "inaccessible favouriting" do
      let(:role) { :member }
    end
  end

  context "When I'm pending member" do
    it_behaves_like "inaccessible favouriting" do
      let(:role) { :pending }
    end
  end
end
