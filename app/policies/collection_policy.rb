class CollectionPolicy < Struct.new(:membership, :collection)
  def new?
    membership.admin?
  end

  def create?
    membership.admin?
  end
end
