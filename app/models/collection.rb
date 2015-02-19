class Collection < ActiveRecord::Base
  VISIBLE_COLLECTIONS_COUNT = 3

  include RankedModel

  belongs_to :group, counter_cache: true, required: true
  has_many :collection_posts, -> { ordered }, dependent: :destroy
  has_many :posts, through: :collection_posts
  accepts_nested_attributes_for :collection_posts, allow_destroy: true

  validates :name, :image, presence: true
  validates :name, uniqueness: true

  mount_uploader :image, ImageUploader

  scope :visible, -> { where(visibility: true) }
  scope :not_used_for, -> (post) { where.not(id: post.collections.pluck(:id)) }
  scope :ordered, -> { rank(:row_order) }

  ranks :row_order, with_same: :group_id

  def collection_post_for(post)
    collection_posts.where(post: post).first
  end
end
