class Collection < ActiveRecord::Base
  include RankedModel

  belongs_to :group, counter_cache: true, required: true
  has_many :collection_posts, -> { ordered }, dependent: :destroy
  has_many :posts, through: :collection_posts
  accepts_nested_attributes_for :collection_posts, allow_destroy: true

  validates :name, :image, presence: true
  validates :name, uniqueness: true

  mount_uploader :image, ImageUploader

  scope :for_display, -> { limit(3) }  # TODO
  scope :for_dropdown, -> { limit(3) } # TODO
  scope :ordered, -> { rank(:row_order) }

  ranks :row_order, with_same: :group_id

  def posts_count
    3 # TODO
  end
end
