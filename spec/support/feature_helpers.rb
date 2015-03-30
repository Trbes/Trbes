DEFAULT_HOST = "lvh.me"
DEFAULT_PORT = 9887

module FeatureHelpers
  def sign_in(email, password)
    visit new_user_session_path

    fill_in "Email Address", with: email
    fill_in "Password", with: password

    click_button "Sign in"
  end

  def switch_to_subdomain(subdomain)
    Capybara.app_host = "http://#{subdomain}.#{DEFAULT_HOST}:#{DEFAULT_PORT}"
  end

  def switch_to_main
    Capybara.app_host = "http://#{DEFAULT_HOST}:#{DEFAULT_PORT}"
  end

  def create_link_post
    page.find("#btn_add_post").click

    expect(page).to have_content("POST TYPE: LINK")

    fill_in "Link", with: "http://sample-link.com"
    fill_in "Title", with: "Long enough title"
    fill_in "Tagline", with: "Tagline"

    click_button "Publish Post"

    expect(page).to have_content("Long enough title")
  end
end

RSpec.configure do |config|
  Capybara.default_host = "http://#{DEFAULT_HOST}"
  Capybara.server_port = DEFAULT_PORT
  Capybara.app_host = "http://#{DEFAULT_HOST}:#{Capybara.server_port}"
  Capybara.default_wait_time = 5

  config.before :each, :js, type: :feature do |example|
    if example.metadata[:js]
      page.driver.block_unknown_urls
      page.driver.allow_url("lvh.me")
    end
  end

  config.include FeatureHelpers, type: :feature
end

shared_context "group membership and authentication" do
  let(:membership) { create(:membership) }
  let(:user) { membership.user }
  let(:group) { membership.group }

  background do
    membership.member!
    switch_to_subdomain(group.subdomain)
    sign_in(user.email, "123456")
  end

  after { switch_to_main }
end
