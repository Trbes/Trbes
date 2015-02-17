class CollectionPolicy < Struct.new(:membership, :collection)
  def index?
    true
  end

  def new?
    membership.owner? || membership.moderator?
  end

  def create?
    membership.owner? || membership.moderator?
  end

  def show?
    true
  end

  def edit?
    membership.owner? || membership.moderator?
  end

  def update?
    membership.owner? || membership.moderator?
  end

  def destroy?
    membership.owner? || membership.moderator?
  end
end
