source "https://rubygems.org"

ruby ENV["CUSTOM_RUBY_VERSION"] || "2.2.2"

# the most important stuff
gem "rails", "4.2.1"
gem "pg"

# frontend stack: preprocessors, libraries, minifiers, assets
# plus view stack: helpers, builders, etc.
gem "sprockets", "2.12.3"
gem "sass"
gem "sass-rails"
gem "slim"
gem "coffee-rails"
gem "jquery-rails"
gem "jquery-ui-rails"
gem "autoprefixer-rails"
gem "therubyracer", platforms: :ruby
gem "uglifier"
gem "best_in_place", git: "https://github.com/codynguyen/best_in_place", branch: "cross-browser-behaviour"
gem "retina_tag"
gem "angular-rails-templates"
gem "angular_rails_csrf"

gem "simple_form", "~> 3.1"
gem "nested_form"
gem "active_link_to"
gem "title"
gem "flutie"

# all other gems
gem "devise"
gem "devise_invitable"
gem "decent_exposure"
gem "kaminari"
gem "bootstrap-kaminari-views"
gem "seedbank"
gem "puma"
gem "interactor-rails"
gem "factory_girl_rails"
gem "faker"
gem "carrierwave"
gem "cloudinary"
gem "pundit"
gem "acts_as_votable"
gem "friendly_id"
gem "algoliasearch-rails"
gem "gon"
gem "attribute_normalizer"
gem "sucker_punch"
gem "ranked-model"
gem "omniauth"
gem "omniauth-twitter"
gem "omniauth-facebook"
gem "omniauth-google-oauth2"
gem "omniauth-linkedin-oauth2"
# Switch back to original version when patch gets merged
gem "paranoia"
gem "rest-client", "~> 1.8.0"
gem "mobile-fu"
gem "crack"
gem "sanitize"
gem "counter_culture"
gem "gaffe"
gem "active_model_serializers"

group :staging, :production do
  gem "airbrake"
  gem "newrelic_rpm"
  gem "rails_12factor"
end

group :test do
  gem "capybara"
  gem "capybara-webkit"
  gem "capybara-select2"
  gem "capybara-angular"
  gem "database_cleaner"
  gem "selenium-webdriver"
  gem "poltergeist"
  gem "email_spec"
  gem "formulaic"
  gem "launchy"
  gem "shoulda-matchers"
  gem "webmock", require: false
end

group :development, :test do
  gem "awesome_print"
  gem "brakeman", "~> 3.0.3", require: false
  gem "bundler-audit"
  gem "byebug"
  gem "dotenv-rails"
  gem "fuubar", "~> 2.0"
  gem "pry-rails"
  gem "rails_best_practices"
  gem "rspec-rails", "~> 3.1"
  gem "rubocop"
  gem "sinatra"
end

group :development do
  gem "bullet"
  gem "foreman"
  gem "quiet_assets"
  gem "letter_opener"
  gem "slim-rails", "~> 3.0.1"
end

# Assets gems from rails-assets.org
source "https://rails-assets.org" do
  gem "rails-assets-bootstrap-sass-official"
  gem "rails-assets-bootstrap-social"
  gem "rails-assets-breakpoint-sass"
  gem "rails-assets-animate.css"
  gem "rails-assets-bourbon"
  gem "rails-assets-font-awesome"
  gem "rails-assets-webhostinghub-glyphs"

  gem "rails-assets-modernizr"
  gem "rails-assets-html5shiv"
  gem "rails-assets-respond"
  gem "rails-assets-enquire"
  gem "rails-assets-jquery-validation"
  gem "rails-assets-jquery-form"
  gem "rails-assets-humane"
  gem "rails-assets-zeroclipboard"
  gem "rails-assets-select2"
  gem "rails-assets-jquery-autosize"
  gem "rails-assets-underscore"
  gem "rails-assets-is-loading"

  gem "rails-assets-angular"
  gem "rails-assets-angular-ui-router"
  gem "rails-assets-angular-devise"
  gem "rails-assets-angular-sanitize"
  gem "rails-assets-angular-resource"
  gem "rails-assets-angular-route"
  gem "rails-assets-angular-animate"
  gem "rails-assets-angular-moment"
  gem "rails-assets-angular-bootstrap"
  gem "rails-assets-angular-truncate-asset"
end
