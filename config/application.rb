require File.expand_path("../boot", __FILE__)

require "rails/all"

Bundler.require(:default, Rails.env)

module Trbes
  class Application < Rails::Application
    config.slim_options = {}
    config.noreply = "noreply@fs-rails-base.heroku.com"
    config.host = "localhost:5000"
    config.active_record.raise_in_transactional_callbacks = true

    config.to_prepare do
      Devise::Mailer.layout "devise_mailer"
    end
  end
end
