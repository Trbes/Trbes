# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

Rails.application.config.assets.paths << Rails.root.join(
  'vendor', 'assets', 'bower_components')
Rails.application.config.assets.paths << Rails.root.join(
  'vendor', 'assets', 'bower_components', 'bootstrap-sass-official', 'assets', 'fonts')
Rails.application.config.assets.paths << Rails.root.join(
  'vendor', 'assets', 'bower_components', 'font-awesome', 'fonts')
Rails.application.config.assets.paths << Rails.root.join(
  'app', 'assets', 'fonts')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile << /.*.(?:eot|svg|ttf|woff)$/
Rails.application.config.assets.precompile += %w( modernizr/modernizr.js )
Rails.application.config.assets.precompile += %w( ielt9_support.js )
