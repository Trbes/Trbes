class GroupMailer < ApplicationMailer
  helper ApplicationHelper
  helper GroupsHelper
  helper PostsHelper

  def weekly_digest_email(membership)
    @membership = membership
    @posts = @membership.group.posts.for_weekly_digest

    mail_with_mailkick(to: membership.user_email, subject: "Weekly digest for #{@membership.group_name}")
  end
end
