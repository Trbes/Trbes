require File.expand_path("../boot", __FILE__)

require "rails/all"

Bundler.require(:default, Rails.env)

module Trbes
  class Application < Rails::Application
    config.slim_options = {}
    config.noreply = ENV["NOREPLY_EMAIL"] || "noreply@trbes.com"
    config.host = ENV["APP_HOST"] || "trbes.com"
    config.action_dispatch.tld_length = ENV["TLD_LENGTH"].to_i || 1
    config.active_record.raise_in_transactional_callbacks = true

    config.to_prepare do
      Devise::Mailer.layout "mailer"
    end
  end
end
