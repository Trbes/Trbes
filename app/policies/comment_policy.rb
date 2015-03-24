class CommentPolicy < Struct.new(:membership, :comment)
  def create?
    membership.present?
  end

  def create_nested?
    create? && comment.root?
  end

  def destroy?
    comment.user == membership.user
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
    comment.user == membership.user || (membership.owner? || membership.moderator?)
  end

  def destroy?
    comment.user == membership.user || (membership.owner? || membership.moderator?)
  end
end
