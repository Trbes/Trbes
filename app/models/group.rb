class Group < ActiveRecord::Base
  include AlgoliaSearch
  include AllowedPostTypes

  has_many :posts, dependent: :destroy
  has_many :comments, through: :posts

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  has_many :collections, dependent: :destroy

  validates :name, :subdomain, presence: true, uniqueness: true
  validates :subdomain, subdomain: true

  normalize_attributes :name, :description, :subdomain

  has_one :logo, as: :attachable, class_name: "Attachment"
  accepts_nested_attributes_for :logo, update_only: true

  delegate :image, to: :logo, prefix: true, allow_nil: true

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
    memberships.first.user # TODO
  end

  def moderators
    memberships.sample(3) # TODO
  end

  def add_member(user, opts = {})
    role_name = (opts[:as] || :member).to_s

    membership = memberships.find_or_create_by(user: user)
    role = Role.find_or_create_by(name: role_name)
    membership.membership_roles.find_or_create_by(role: role)
  end
end
