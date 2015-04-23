class Group < ActiveRecord::Base
  include AlgoliaSearch

  VISIBLE_MEMBERS_COUNT = 5

  has_many :posts, dependent: :destroy
  has_many :comments, through: :posts

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  has_many :collections, dependent: :destroy

  validates :name, :subdomain, presence: true, uniqueness: true
  validates :name, length: { minimum: 2 }
  validates :subdomain, length: { minimum: 2, maximum: 20 }
  validates :tagline, presence: true, length: { minimum: 2 }
  validates :subdomain, subdomain: true
  validates :custom_domain, domain: true, uniqueness: true, allow_nil: true, allow_blank: true

  normalize_attributes :name, :description, :subdomain, :custom_domain, :tagline

  delegate :full_name, :avatar, to: :owner, prefix: true

  scope :all_public, -> { where(private: false) }
  scope :order_by_created_at, -> { order(created_at: :desc) }

  algoliasearch per_environment: true, disable_indexing: Rails.env.test? || ENV["ALGOLIASEARCH_DISABLED"].present? do
    attribute :name, :subdomain
  end

  acts_as_paranoid

  mount_uploader :logo, ImageUploader

  def comments_count
    posts.pluck(:comments_count).inject(:+) || 0
  end

  def notifications_count
    memberships.pending.count + posts.moderation.count + comments.moderation.count
  end

  def owner
    memberships.owner.first
  end

  def moderators
    memberships.moderator
  end

  def add_member(user, opts = {})
    role_name = (opts[:as] || :member)

    memberships.where(user: user, role: role_name).first_or_create
  end

  def allowed_post_types
    %w(link_post text_post image_post).select do |post_type|
      self["allow_#{post_type}s"]
    end
  end

  def default_post_type
    allowed_post_types.first
  end
end
