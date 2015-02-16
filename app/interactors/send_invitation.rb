class SendInvitation
  include Interactor

  def call
    SendInvitationEmailJob.perform_later(
      context.inviter.id,
      context.group.id,
      context.email_addresses
    )
  end
end
