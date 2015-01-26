class CollectionPolicy < Struct.new(:membership, :collection)
  def index?
    true
  end

  def new?
    membership.admin?
  end

  def create?
    membership.admin?
  end

  def show?
    true
  end

  def edit?
    membership.admin?
  end

  def update?
    membership.admin?
  end

  def destroy?
    membership.admin?
  end
end
