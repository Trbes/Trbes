class InvitationMailer < ApplicationMailer
  def invitation_email(user, group, invited_user)
    @user = user
    @group = group
    @invited_user = invited_user
    mail(to: invited_user.email, subject: "A new place for us to share about #{group.description}.")
  end
end
