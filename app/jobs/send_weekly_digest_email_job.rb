class SendWeeklyDigestEmailJob < ActiveJob::Base
  queue_as :default

  def perform(membership_id)
    membership = Membership.find(membership_id)

    GroupMailer.weekly_digest_email(membership).deliver_now
  end
end
