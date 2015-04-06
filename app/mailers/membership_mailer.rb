class MembershipMailer < ApplicationMailer
  def role_changed_email(membership)
    @membership = membership

    mail to: @membership.email,
      subject: "Your role in #{@membership.group_name} has changed",
      template_path: "membership_mailer/role_changed",
      template_name: membership.role
  end
end
