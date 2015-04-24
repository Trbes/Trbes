class GroupPolicy < Struct.new(:membership_or_user, :group)
  def create?
    membership_or_user
  end

  def show_notifications_badge?(current_path)
    !current_path.include?("admin") && group.notifications_count > 0
  end

  def show_extra_memberships?
    group.memberships_count > ::Group::VISIBLE_MEMBERS_COUNT
  end

  def edit?
    membership_or_user.owner? || membership_or_user.moderator?
  end

  def update?
    membership_or_user.owner?
  end

  def destroy?
    membership_or_user.owner?
  end

  def show?
    !group.private? || membership_or_user && !membership_or_user.pending?
  end
end
