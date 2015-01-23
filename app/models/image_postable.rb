class ImagePostable < ActiveRecord::Base
  has_one :post, as: :postable

  validates :image, presence: true
end
