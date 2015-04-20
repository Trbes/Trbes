class CollectionPost < ActiveRecord::Base
  include RankedModel

  scope :ordered, -> { rank(:row_order) }
  scope :for_post, -> (post) { where(post_id: post.id) }

  belongs_to :post, required: true, touch: true
  belongs_to :collection, required: true, counter_cache: true, inverse_of: :collection_posts

  delegate :image, :name, to: :collection, prefix: true

  ranks :row_order, with_same: :collection_id
end
