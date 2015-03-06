class PostPolicy < Struct.new(:membership, :post)
  def edit?
    membership.moderator? || membership.owner? || membership && post.editable?
  end

  def update?
    membership.moderator? || membership.owner? || membership && post.editable?
  end

  def publish?
    membership && (membership.owner? || membership.moderator? || membership.member?)
  end

  def vote?(user)
    user
  end
end
