class InvitationMailer < ApplicationMailer

  def invitation_email(user, group, email_addresses)
    @user = user
    @group = group
    mail(to: email_addresses, subject: "A new place for us to share about #{group.description}.")
  end
end
