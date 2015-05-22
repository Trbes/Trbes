class GroupMailer < ApplicationMailer
  helper ApplicationHelper
  helper GroupsHelper
  helper PostsHelper

  def weekly_digest_email(user)
    @user = user

    mail_with_mailkick(to: @user.email, subject: "Weekly digest from your groups")
  end
end
