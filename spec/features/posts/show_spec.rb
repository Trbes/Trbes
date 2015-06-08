require "rails_helper"

feature "Single post page" do
  include_context "group membership and authentication"

  let!(:post) { create(:post, :text, group: group) }

  before(:each) do
    visit root_path
  end

  scenario "I visit single post page", js: true do
    visit post_path(post)

    expect(current_path).to eq("/#{post.title.parameterize}")

    within("#post_#{post.id}") do
      expect(page).to have_css(".post-title", text: post.title)
      expect(page).to have_css(".post-body", text: post.body)

      find("a.share").click
      expect(page).to have_css("ul.dropdown-menu", visible: true)
    end

    within("ul.dropdown-menu") do
      facebook_share_link = page.find(".share-on-facebook")
      expect(facebook_share_link["data-title"]).to eql post.title
      expect(facebook_share_link["data-link"]).to include(group.subdomain)
      expect(facebook_share_link["data-link"]).to include(post.slug)

      twitter_share_link = page.find(".share-on-twitter")
      expect(twitter_share_link["href"]).to include(post.slug)
      expect(twitter_share_link["href"]).to include(URI.encode(post.title))
      expect {
        twitter_share_link.click
      }.to change { Capybara.current_session.windows.size }.by(1)
    end

    new_window = Capybara.current_session.windows.last

    page.within_window new_window do
      url = URI.parse(page.current_url)
      expect(url.host).to include("twitter")
    end
  end

  context "When the post is from another group" do
    let!(:post_from_another_group) { create(:post, group: create(:group)) }

    scenario "I see an exception" do
      visit post_path(post_from_another_group)

      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end

  context "when post is in 'moderation' state and I'm not it's author or moderator" do
    let!(:post_on_moderation) do
      create(:post, state: :moderation, group: group, membership: create(:membership))
    end

    background do
      membership.member!
    end

    scenario "I can't access it" do
      expect(current_path).to eq(root_path)
      expect(page).not_to have_content(post_on_moderation.title)
    end
  end

  context "when post is deleted" do
    let!(:deleted_post) { create(:post, group: group, deleted_at: Date.today) }

    context "when I'm post author" do
      background do
        deleted_post.update(membership: membership)

        visit post_path(deleted_post)
      end

      scenario "I can visit post page" do
        expect(current_path).to eq(post_path(deleted_post.title.parameterize))

        within("#post_#{deleted_post.id}") do
          expect(page).to have_css(".post-title", text: deleted_post.title)
          expect(page).to have_css(".post-body", text: deleted_post.body)
        end
      end
    end

    context "when I'm not a post author" do
      context "when I'm group member" do
        background do
          deleted_post.update(membership: create(:membership, group: group))
          membership.member!

          visit post_path(deleted_post)
        end

        scenario "I can't visit post page" do
          expect(current_path).to eq(root_path)
          expect(page).not_to have_content(deleted_post.title)
        end
      end

      context "when I'm group moderator" do
        background do
          membership.moderator!

          visit post_path(deleted_post)
        end

        scenario "I can visit post page" do
          expect(current_path).to eq(post_path(deleted_post.title.parameterize))

          within("#post_#{deleted_post.id}") do
            expect(page).to have_css(".post-title", text: deleted_post.title)
            expect(page).to have_css(".post-body", text: deleted_post.body)
          end
        end
      end
    end
  end

  context "when I'm logged in" do
    scenario "I upvote for a post", js: true do
      expect(post.cached_votes_total).to eq(0)

      page.find("#post_#{post.id} .vote").click
      wait_for_ajax
      expect(post.reload.cached_votes_total).to eql 1

      within("#post_#{post.id} .vote-count") do
        expect(page).to have_content(1)
      end

      expect {
        page.find("#post_#{post.id} .vote").click
        wait_for_ajax
      }.not_to change { post.cached_votes_total }
    end
  end

  context "when I'm not logged in", js: true do
    background do
      click_link user.full_name
      click_link "Sign out"
      visit post_path(post)
    end

    scenario "I can't upvote for a post" do
      expect(page.find(".vote")["href"]).to eq(new_user_registration_path)
    end

    context "when group is private and I'm unconfirmed member" do
      background do
        membership.pending!
        group.update_attributes(private: true)
      end

      scenario "I can't read it's posts" do
        visit post_path(post)

        expect(current_path).to eq(new_user_session_path)
        expect(page).not_to have_content(post.title)
      end
    end
  end
end
