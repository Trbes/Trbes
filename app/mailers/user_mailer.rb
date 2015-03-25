class UserMailer < ApplicationMailer
  default from: "hello@trbes.com"

  def invitation_email(user, group, invited_user)
    @user = user
    @group = group
    @invited_user = invited_user
    mail(from: user.email, to: invited_user.email, subject: "A new place for us to share about #{group.tagline}.")
  end

  def welcome_email(user)
    @user = user
    mail(to: user.email, subject: "WELCOME TO TRBES")
  end
end
