class CollectionPost < ActiveRecord::Base
  belongs_to :post, required: true
  belongs_to :collection, required: true
end
