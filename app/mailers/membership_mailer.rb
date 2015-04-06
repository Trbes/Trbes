class MembershipMailer < ApplicationMailer
  def role_changed_email(membership)
    @membership = membership
    mail to: @membership.email,
      subject: "Your role in #{@membership.group_name} has changed",
      template_path: "membership_mailer/role_changed",
      template_name: membership.role
  end

  def welcome_email(user)
    @user = user
    mail(to: user.email, subject: "WELCOME TO TRBES")
  end
end
