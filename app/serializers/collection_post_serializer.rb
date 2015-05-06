class CollectionPostSerializer < ActiveModel::Serializer
  attributes \
    :id,
    :post_id,
    :admin_collection_post_path

  has_one :collection

  def admin_collection_post_path
    scope.admin_collection_post_path(object)
  end
end
