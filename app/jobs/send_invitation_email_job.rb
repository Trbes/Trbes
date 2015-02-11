# app/jobs/send_invitation_email_job.rb

class SendInvitationEmailJob
  include SuckerPunch::Job

  def perform(user_id, group_id, email_addresses)
    user = User.find user_id
    group = Group.find group_id
    email_addresses = email_addresses.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i)
    InvitationMailer.invitation_email(user, group, email_addresses).deliver_now
  end
end
