require File.expand_path("../boot", __FILE__)

require "rails/all"

Bundler.require(*Rails.groups)

module Trbes
  class Application < Rails::Application
    # config.slim_options = {}
    config.noreply = ENV["NOREPLY_EMAIL"] || "noreply@trbes.com"
    config.host = ENV["APP_HOST"] || "trbes.com"
    config.action_controller.default_url_options = { host: ENV["APP_HOST"] || "trbes.com" }
    config.action_dispatch.tld_length = [ENV["TLD_LENGTH"].to_i, 1].max
    config.active_record.raise_in_transactional_callbacks = true

    config.to_prepare do
      Devise::Mailer.layout "mailer"
      DeviseController.respond_to :html, :json
    end

    config.before_initialize do |app|
      require 'sprockets'
      require 'tilt'
      require 'angular-rails-templates'

      mimeless_slim = Class.new(Tilt[:slim]) do
        def self.default_mime_type
          nil
        end
      end

      Sprockets::Engines #force autoloading
      Sprockets.register_engine '.slim', mimeless_slim
      Sprockets.register_engine '.html', AngularRailsTemplates::Template
    end
  end
end
