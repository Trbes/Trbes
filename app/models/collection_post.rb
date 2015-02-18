class CollectionPost < ActiveRecord::Base
  include RankedModel

  belongs_to :post, required: true
  belongs_to :collection, required: true

  ranks :row_order, with_same: :collection_id
  scope :ordered, -> { rank(:row_order) }
end
