class ImagePostable < ActiveRecord::Base
  has_one :post, as: :postable

  # validates :image, presence: true

  def preview_image
    "https://placekitten.com/g/#{rand(8) + 1}00/#{rand(8) + 1}00"
  end
end
