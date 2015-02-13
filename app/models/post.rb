class Post < ActiveRecord::Base
  include AlgoliaSearch
  extend FriendlyId

  enum post_type: %i(text_post link_post image_post)

  scope :order_by_votes, -> { order(cached_votes_total: :desc) }
  scope :order_by_created_at, -> { order(created_at: :desc) }

  has_many :comments, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :group, counter_cache: true, required: true
  belongs_to :user, required: true

  validates :title, presence: true
  validates :title, length: { minimum: 10, maximum: 100 }
  validates_presence_of :body, if: Proc.new { |p| p.post_type == :text_post }

  delegate :full_name, :avatar, to: :user, prefix: true

  acts_as_votable

  paginates_per 20

  friendly_id :title, use: %i( slugged finders )

  normalize_attributes :title
  normalize_attributes :body, with: :squish

  algoliasearch do
    attribute :title, :body, :slug

    tags do
      ["group_#{group_id}"]
    end
  end

  def preview_image
    attachments.first.image if attachments.any?
  end
end
