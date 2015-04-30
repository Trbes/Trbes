class CommentPolicy < Struct.new(:membership, :comment)
  class Scope
    attr_reader :membership, :scope

    def initialize(membership, scope)
      @membership = membership
      @scope = scope
    end

    def resolve
      if membership && (membership.owner? || membership.moderator?)
        scope.all
      else
        scope.published_or_authored_by(membership)
      end
    end
  end

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
