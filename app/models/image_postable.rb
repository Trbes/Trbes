class ImagePostable < ActiveRecord::Base
  has_one :post, as: :postable

  validates :image, presence: true

  def self.human_name
    'Image Post'
  end
end
