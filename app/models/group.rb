class Group < ActiveRecord::Base
  include AlgoliaSearch

  has_many :posts, dependent: :destroy
  has_many :memberships, dependent: :destroy

  validates :name, :subdomain, presence: true, uniqueness: true
  validates :subdomain, subdomain: true

  algoliasearch do
    attribute :name, :subdomain
  end
end
