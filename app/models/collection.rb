class Collection < ActiveRecord::Base
  belongs_to :group, counter_cache: true, required: true

  validates :name, :image, presence: true
  validates :name, uniqueness: true

  mount_uploader :image, ImageUploader

  def posts_count
    3
  end
end
