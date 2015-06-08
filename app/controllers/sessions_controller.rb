class SessionsController < Devise::SessionsController
  skip_before_action :authorize_group_access, only: %i(new create)
  after_action :after_login, only: :create

  def after_login
    return unless current_group &&
        (pending_memberships_count = current_group.memberships.pending.count) > 0 &&
        (current_membership.owner? || current_membership.moderator?)

    flash[:alert] = I18n.t("app.group.message.pending_members", count: pending_memberships_count)
  end
end
