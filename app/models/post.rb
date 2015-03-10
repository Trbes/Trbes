class Post < ActiveRecord::Base
  include AlgoliaSearch
  extend FriendlyId

  enum post_type: %i(text_post link_post image_post)
  enum state: %i(moderation published)

  scope :order_by_votes, -> { order(cached_votes_total: :desc) }
  scope :order_by_created_at, -> { order(created_at: :desc) }
  scope :order_by_trending, -> { order(hot_rank: :desc) }
  scope :for_collection, -> (collection_id) { where(collection_posts: { collection_id: collection_id }) }

  has_many :comments, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :collection_posts, dependent: :destroy
  has_many :collections, through: :collection_posts
  belongs_to :group, counter_cache: true, required: true
  belongs_to :user, required: true

  accepts_nested_attributes_for :attachments

  validates :title, presence: true
  validates :title, length: { minimum: 10, maximum: 100 }
  validates :body, presence: true, if: proc { |p| p.text_post? }
  validates :link, presence: true, if: proc { |p| p.link_post? }

  delegate :full_name, :avatar, :title, to: :user, prefix: true

  before_save :set_hot_rank

  acts_as_votable

  paginates_per 20

  friendly_id :title, use: %i( slugged finders )

  normalize_attributes :title
  normalize_attributes :body, with: :squish

  algoliasearch per_environment: true, disable_indexing: Rails.env.test? do
    attribute :title, :body, :slug

    tags do
      ["group_#{group_id}"]
    end
  end

  acts_as_paranoid

  def preview_image
    attachments.first.image if attachments.any?
  end

  def editable?
    created_at >= 15.minutes.ago
  end

  def written_by?(membership)
    user.id == membership.user_id
  end

  def set_hot_rank
    order = Math.log([cached_votes_total, 1].max, 10)
    seconds = created_at.to_i - 1134028003
    self.hot_rank = (order + seconds / 45000.0).round(7)
  end
end
