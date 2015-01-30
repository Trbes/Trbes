class Membership < ActiveRecord::Base
  belongs_to :user, required: true
  belongs_to :group, required: true

  has_many :membership_roles
  has_many :roles, through: :membership_roles

  scope :for_group, -> (group) { where(group_id: group.id) }

  def make_admin!
    roles << Role.admin
  end

  def admin?
    role?(:admin)
  end

  def role?(role)
    role_names = roles.collect(&:name)

    role_names.include?(role.to_s)
  end
end
