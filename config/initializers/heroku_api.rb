require 'platform-api'

::HerokuClient = PlatformAPI.connect_oauth(ENV["HEROKU_API_TOKEN"])
