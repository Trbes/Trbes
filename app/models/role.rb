class Role < ActiveRecord::Base
  has_many :membership_roles
  has_many :memberships, through: :membership_roles

  def self.admin
    where(name: "admin").first_or_create
  end
end
