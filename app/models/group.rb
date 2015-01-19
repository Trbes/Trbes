class Group < ActiveRecord::Base
  has_many :posts, dependent: :destroy

  validates :name, :subdomain, presence: true, uniqueness: true
  validates :subdomain, subdomain: true
end
