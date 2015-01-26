class Collection < ActiveRecord::Base
  belongs_to :group, required: true

  validates :name, :image, presence: true
  validates :name, uniqueness: true

  mount_uploader :image, ImageUploader
end
