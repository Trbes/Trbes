class Role < ActiveRecord::Base
  ALLOWED_ROLES = %i( admin owner moderator member )

  has_many :membership_roles
  has_many :memberships, through: :membership_roles

  class << self
    ALLOWED_ROLES.each do |role|
      define_method(role.to_s) do
        where(name: role.to_s).first_or_create
      end
    end
  end
end
