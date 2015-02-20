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
