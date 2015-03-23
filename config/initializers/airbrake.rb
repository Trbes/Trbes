if %w(production staging).include?(Rails.env)
  Airbrake.configure do |config|
    config.api_key = ENV["AIRBRAKE_API_KEY"]
  end
end
