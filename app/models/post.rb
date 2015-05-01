class Post < ActiveRecord::Base
  DATE_RANKING_INTRODUCED = DateTime.new(2015, 1, 1).to_i
  ONE_RANKING_POINT_WEIGHT = 12.5.hours

  include Postable
  include AlgoliaSearch
  extend FriendlyId

  enum post_type: %i(text_post link_post image_post)
  enum state: %i(moderation published rejected)

  scope :order_by_votes, -> { order(cached_votes_total: :desc, created_at: :desc) }
  scope :order_by_created_at, -> { order(created_at: :desc) }
  scope :order_by_trending, -> { order(hot_rank: :desc, created_at: :desc) }
  scope :for_collection, -> (collection_id) { where(collection_posts: { collection_id: collection_id }) }
  scope :for_membership, -> (membership) { where(membership_id: membership.id) }

  has_many :comments, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :collection_posts, dependent: :destroy
  has_many :collections, through: :collection_posts
  belongs_to :group, counter_cache: true, required: true
  counter_culture :group,
    column_name: proc { |model| "#{model.state}_posts_count" },
    column_names: {
      ["posts.state = ?", 0] => "moderation_posts_count",
      ["posts.state = ?", 1] => "published_posts_count",
      ["posts.state = ?", 2] => "rejected_posts_count"
    }

  belongs_to :membership, required: true

  accepts_nested_attributes_for :attachments, reject_if: proc { |a| a[:image].blank? }

  validates :title, presence: true
  validates :title, length: { minimum: 5, maximum: 100 }
  validates :body, presence: true, if: proc { |p| p.text_post? }
  validates :link, presence: true, if: proc { |p| p.link_post? }

  validates :post_type, inclusion: { in: proc { |post| post.group.allowed_post_types } }

  delegate :user_full_name, :user_avatar_url, :user_title, to: :membership

  after_save :set_hot_rank

  acts_as_votable

  paginates_per 20

  friendly_id :title, use: %i( slugged finders )

  normalize_attributes :title
  normalize_attributes :body, with: %i( htmlize squish )

  algoliasearch per_environment: true, disable_indexing: Rails.env.test? || ENV["ALGOLIASEARCH_DISABLED"].present? do
    attribute :title, :body, :slug, :state

    tags do
      ["group_#{group_id}"]
    end

    attributesForFaceting [:state]
  end

  acts_as_paranoid

  def preview_image
    attachments.first.image if attachments.any?
  end

  def set_hot_rank
    order = Math.log([cached_votes_total, 1].max, 10)
    seconds = created_at.to_i - DATE_RANKING_INTRODUCED

    update_column(:hot_rank, (order + seconds / ONE_RANKING_POINT_WEIGHT).round(7))
  end
end
