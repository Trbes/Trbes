class CollectionPostPolicy < Struct.new(:membership, :collection_post)
  def create?
    membership && (membership.owner? || membership.moderator?) && membership.group.collections.exists?
  end

  def destroy?
    membership && (membership.owner? || membership.moderator?)
  end
end
