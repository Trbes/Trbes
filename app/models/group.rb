class Group < ActiveRecord::Base
  validates :name, :subdomain, presence: true
  validates :subdomain, subdomain: true
end
