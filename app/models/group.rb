class Group < ActiveRecord::Base
  include AlgoliaSearch

  has_many :posts, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :collections, dependent: :destroy

  validates :name, :subdomain, presence: true, uniqueness: true
  validates :subdomain, subdomain: true

  normalize_attributes :name, :description, :subdomain

  algoliasearch do
    attribute :name, :subdomain

    attribute :posts do
      posts.map do |post|
        { title: post.title, content: post.content }
      end
    end
  end
end
