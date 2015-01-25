class Role < ActiveRecord::Base
  has_and_belongs_to_many :memberships

  def self.admin
    where(name: "admin").first_or_create
  end
end
