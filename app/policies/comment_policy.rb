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
end
