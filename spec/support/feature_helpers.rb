DEFAULT_HOST = "vcap.me"
DEFAULT_PORT = 9887

module FeatureHelpers
  def sign_in(email, password)
    visit new_user_session_path

    fill_in "Email Address", with: email
    fill_in "Password", with: password

    click_button "Sign in"
  end

  def sign_out
    click_link "Sign out"
  end

  def switch_to_subdomain(subdomain)
    Capybara.app_host = "http://#{subdomain}.#{DEFAULT_HOST}:#{DEFAULT_PORT}"
  end

  def switch_to_main
    Capybara.app_host = "http://#{DEFAULT_HOST}:#{DEFAULT_PORT}"
  end

  def create_post(post_type, options = {})
    page.find("#btn_add_post").click
    expect(page).to have_content("POST TYPE: #{post_type.to_s.upcase}")

    fill_in_post_fields(post_type, options)
    click_button "Publish Post"

    expect(page).to have_content("Long enough title")
  end

  def fill_in_post_fields(post_type, options)
    fill_in "Title", with: options[:title] || "Long enough title"

    public_send("fill_#{post_type}_post_fields", options)
  end

  def fill_link_post_fields(options)
    fill_in "Link", with: options[:link] || "http://sample-link.com"
    fill_in "Tagline", with: options[:tagline] || "Tagline"
  end

  def fill_text_post_fields(options)
    fill_in "Your Text", with: options[:text]
  end

  def fill_image_post_fields(options)
    attach_file "Image", options[:file]
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
      page.driver.allow_url("vcap.me")
    end
  end

  config.include FeatureHelpers, type: :feature
end

shared_context "group membership and authentication" do
  let!(:membership) { create(:membership) }
  let!(:user) { membership.user }
  let!(:group) { membership.group }

  background do
    membership.member!
    switch_to_subdomain(group.subdomain)
    sign_in(user.email, "123456")
  end

  after { switch_to_main }
end
