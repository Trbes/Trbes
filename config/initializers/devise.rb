# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
Devise.setup do |config|
  config.mailer_sender = app_config.noreply
  require "devise/orm/active_record"
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.invited_by_class_name = "User"
  config.invited_by_counter_cache = :invitations_count
  config.allow_unconfirmed_access_for = 2.days
  config.reconfirmable = true
  config.password_length = 6..128
  config.reset_password_within = 6.hours
  config.sign_out_via = :get

  config.omniauth :twitter, ENV["TWITTER_API_KEY"], ENV["TWITTER_API_SECRET"]
  config.omniauth :facebook, ENV["FACEBOOK_APP_ID"], ENV["FACEBOOK_APP_SECRET"]
  config.omniauth :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"]
  config.omniauth :linkedin, ENV["LINKEDIN_API_KEY"], ENV["LINKEDIN_API_SECRET"]
end
