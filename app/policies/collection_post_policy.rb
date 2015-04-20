class CollectionPostPolicy < Struct.new(:membership, :collection_post)
  def create?
    membership && (membership.owner? || membership.moderator?)
  end

  def create_for?(post, available_collections)
    create? && available_collections.any? && !post.collection_posts.any?
  end

  def update?
    create?
  end

  def destroy?
    membership && (membership.owner? || membership.moderator?)
  end
end
