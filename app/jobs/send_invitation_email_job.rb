# app/jobs/send_invitation_email_job.rb
class SendInvitationEmailJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, group_id, email_addresses)
    @user = User.find user_id
    @group = Group.find group_id

    email_addresses = email_addresses.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i)
    email_addresses.each do |email|
      transaction do
        invite_user_with_email(email)
      end
    end
  end

  private

  def invite_user_with_email(email)
    invited_user = User.invite!({ email: email }, @user) do |u|
      u.skip_invitation = true
    end

    InvitationMailer.invitation_email(@user, @group, invited_user).deliver_now
    @group.add_member(invited_user, as: :moderator)
  end
end
