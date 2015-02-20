class CollectionPostPolicy < Struct.new(:membership, :collection_post)
  def destroy?
    membership.owner? || membership.moderator?
  end
end
