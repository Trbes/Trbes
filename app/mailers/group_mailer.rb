class GroupMailer < ApplicationMailer
  layout "mailer"

  helper ApplicationHelper
  helper GroupsHelper

  def weekly_digest_email(membership)
    @membership = membership
    @posts = @membership.group.posts.for_weekly_digest

    mail(to: membership.user_email, subject: "Weekly digest for #{@membership.group_name}")
  end
end
