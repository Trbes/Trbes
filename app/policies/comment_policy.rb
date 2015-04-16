class CommentPolicy < Struct.new(:membership, :comment)
  def create?
    membership.present?
  end

  def create_nested?
    create? && comment.root?
  end

  def destroy?
    comment.membership == membership
  end

  def publish?
    membership && (membership.owner? || membership.moderator? || membership.member?)
  end

  def favourite?
    membership && (membership.owner? || membership.moderator?)
  end

  def vote?(user)
    user
  end

  def update?
    comment.membership == membership || (membership.owner? || membership.moderator?)
  end

  def destroy?
    comment.membership == membership || (membership.owner? || membership.moderator?)
  end
end
