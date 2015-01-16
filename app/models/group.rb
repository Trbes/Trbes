class Group < ActiveRecord::Base
  validates :name, :subdomain, presence: true
end
