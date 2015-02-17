class Group < ActiveRecord::Base
  include AlgoliaSearch

  ALLOWED_POST_TYPES = %i( link text image )
  attr_accessor :intended_usage

  has_many :posts, dependent: :destroy
  has_many :comments, through: :posts

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  has_many :collections, dependent: :destroy

  validates :name, :subdomain, presence: true, uniqueness: true
  validates :subdomain, subdomain: true

  normalize_attributes :name, :description, :subdomain, :tagline

  has_one :logo, as: :attachable, class_name: "Attachment"
  accepts_nested_attributes_for :logo, update_only: true

  delegate :image, to: :logo, prefix: true, allow_nil: true
  delegate :full_name, :avatar, to: :owner, prefix: true

  algoliasearch do
    attribute :name, :subdomain

    attribute :posts do
      posts.map do |post|
        { title: post.title, body: post.body }
      end
    end
  end

  def comments_count
    posts.pluck(:comments_count).inject(:+)
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
end
