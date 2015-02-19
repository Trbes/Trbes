class CollectionPost < ActiveRecord::Base
  include RankedModel

  scope :ordered, -> { rank(:row_order) }

  belongs_to :post, required: true
  belongs_to :collection, required: true, counter_cache: true

  delegate :image, :name, to: :collection, prefix: true

  ranks :row_order, with_same: :collection_id
end
