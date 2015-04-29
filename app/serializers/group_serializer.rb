class GroupSerializer < ActiveModel::Serializer
  attributes \
    :id,
    :name,
    :tagline,
    :description,
    :join_url,
    :posts_count,
    :will_show_add_collection_hint,
    :will_show_collection_dropdown

  def join_url
    scope.join_url(subdomain: object.subdomain)
  end

  def will_show_add_collection_hint
    object.posts_count == 0 && object.collections_count == 0 && scope.policy(Collection).create?
  end

  def will_show_collection_dropdown
    scope.policy(Collection).create? || object.collections.visible.count > Collection::VISIBLE_COLLECTIONS_COUNT
  end
end
