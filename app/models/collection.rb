class Collection < ActiveRecord::Base
  belongs_to :group, counter_cache: true, required: true

  validates :name, :image, presence: true
  validates :name, uniqueness: true

  mount_uploader :image, ImageUploader

  scope :for_display, -> { limit(3) }  # TODO
  scope :for_dropdown, -> { limit(3) } # TODO

  def posts_count
    3 # TODO
  end
end
