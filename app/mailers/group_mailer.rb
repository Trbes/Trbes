class GroupMailer < ApplicationMailer
  layout "mailer"

  helper ApplicationHelper

  def weekly_digest_email(membership)
    @membership = membership

    mail(to: membership.user_email, subject: "Weekly digest for #{@membership.group_name}")
  end
end
