class PostPolicy < Struct.new(:membership, :post)
  def edit?
    membership && (membership.moderator? || membership.owner? || post.editable?)
  end

  def update?
    edit?
  end

  def destroy?
    membership && (membership.moderator? || membership.owner? || post.written_by?(membership))
  end

  def publish?
    membership && (membership.owner? || membership.moderator? || membership.member?)
  end

  def vote?(user)
    user
  end
end
