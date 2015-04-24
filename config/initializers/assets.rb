# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

Rails.application.config.assets.paths << Rails.root.join("app", "assets", "fonts")
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "flash")

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(
  modernizr/modernizr.js
  ie_lt9.js
  error.css
)
Rails.application.config.assets.precompile << /.*.(?:eot|svg|ttf|woff|woof2|swf)$/
Rails.application.assets.register_engine('.slim', Slim::Template)
