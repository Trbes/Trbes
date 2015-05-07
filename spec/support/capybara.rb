require "capybara/poltergeist"

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app,
    debug: false, # change this to true to troubleshoot
    window_size: [1300, 1000], # this can affect dynamic layout
    js_errors: false,
    timeout: 180,
    phantomjs_logger: Puma::NullIO.new,
    logger: nil,
    phantomjs_options:
    [
      "--load-images=no",
      "--ignore-ssl-errors=yes"
    ]
  )
end

Capybara.configure do |config|
  config.match = :prefer_exact
  config.javascript_driver = :webkit
end

def clear_cookies
  browser = Capybara.current_session.driver.browser
  if browser.respond_to?(:clear_cookies)
    # Rack::MockSession
    browser.clear_cookies
  elsif browser.respond_to?(:manage) && browser.manage.respond_to?(:delete_all_cookies)
    # Selenium::WebDriver
    browser.manage.delete_all_cookies
  else
    fail "Don't know how to clear cookies. Weird driver?"
  end
end
