# config/initializers/sucker_punch.rb
Rails.application.configure do
  config.active_job.queue_adapter = :sucker_punch
end
