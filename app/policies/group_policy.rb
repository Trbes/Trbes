class GroupPolicy < Struct.new(:membership_or_user, :group)
  def create?
    membership_or_user
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
end
