class SendWeeklyDigestEmailJob < ActiveJob::Base
  queue_as :default

  def perform(user_id:)
    user = User.find(user_id)

    GroupMailer.weekly_digest_email(user).deliver_now
  end
end
