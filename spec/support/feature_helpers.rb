module FeatureHelpers
  def sign_in(email, password)
    visit new_user_session_path

    click_link "Sign in"

    fill_form(
      :user,
      email: email,
      password: password
    )

    click_button "Sign in"
  end

  def switch_to_subdomain(subdomain)
    Capybara.app_host = "http://#{subdomain}.#{DEFAULT_HOST}:#{DEFAULT_PORT}"
  end

  def switch_to_main
    Capybara.app_host = "http://#{DEFAULT_HOST}:#{DEFAULT_PORT}"
  end
end
