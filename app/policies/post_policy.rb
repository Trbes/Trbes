class PostPolicy < Struct.new(:membership, :post)
  def show?
    post.published? && !post.deleted? || destroy?
  end

  def display_state?
    !post.published? && post.written_by?(membership) || membership && (membership.moderator? || membership.owner?)
  end

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

  def feature?
    true
  end
end
