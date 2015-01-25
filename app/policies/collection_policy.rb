class CollectionPolicy < Struct.new(:membership, :collection)
  def new?
    membership.is_admin?
  end

  def create?
    membership.is_admin?
  end
end
