class Group < ActiveRecord::Base
  include AlgoliaSearch

  ALLOWED_POST_TYPES = %i( link text image )
  attr_accessor :intended_usage

  has_many :posts, dependent: :destroy
  has_many :comments, through: :posts

  has_many :memberships, dependent: :destroy
  has_many :membership_roles, through: :memberships
  has_many :users, through: :memberships

  has_many :collections, dependent: :destroy

  validates :name, :subdomain, presence: true, uniqueness: true
  validates :subdomain, subdomain: true

  normalize_attributes :name, :description, :subdomain, :tagline

  has_one :logo, as: :attachable, class_name: "Attachment"
  accepts_nested_attributes_for :logo, update_only: true

  delegate :image, to: :logo, prefix: true, allow_nil: true
  delegate :full_name, :avatar, to: :owner, prefix: true
  delegate :owner_membership_role, to: :owner

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
    memberships.with_role(:owner).first
  end

  def moderators
    memberships.includes(:user).sample(3) # TODO
  end

  def add_member(user, opts = {})
    role_name = (opts[:as] || :member).to_s

    membership = memberships.where(user: user).first_or_create
    role = Role.public_send(role_name)
    membership.membership_roles.where(role: role).first_or_create
  end
end
