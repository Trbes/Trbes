class SendInvitation
  include Interactor

  def call
    SendInvitationEmailJob.new.async.perform(
      context.inviter,
      context.group.id,
      context.email_addresses
    )
  end
end
