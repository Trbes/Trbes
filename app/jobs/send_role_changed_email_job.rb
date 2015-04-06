class SendRoleChangedEmailJob < ActiveJob::Base
  queue_as :default

  def perform(membership_id)
    membership = Membership.find(membership_id)
    MembershipMailer.role_changed_email(membership).deliver_now
  end
end
