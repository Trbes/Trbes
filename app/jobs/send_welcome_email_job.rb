# app/jobs/send_welcome_email_job.rb
class SendWelcomeEmailJob < ActiveJob::Base
  queue_as :default

  def perform(user_id)
    @user = User.find user_id
    UserMailer.welcome_email(@user).deliver_now
  end
end
