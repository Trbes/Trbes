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
