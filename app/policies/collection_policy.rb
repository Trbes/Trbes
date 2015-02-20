class CollectionPolicy < Struct.new(:membership, :collection)
  def create?
    membership && (membership.owner? || membership.moderator?)
  end

  def update?
    membership.owner? || membership.moderator?
  end

  def destroy?
    membership.owner? || membership.moderator?
  end
end
