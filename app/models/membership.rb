class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  has_and_belongs_to_many :roles

  scope :for_group, -> (group) { where(group_id: group.id) }

  def make_admin!
    roles << Role.admin
  end

  def is_admin?
    has_role?(:admin)
  end

  def has_role?(role)
    role_names = roles.collect(&:name)

    role_names.include?(role.to_s)
  end
end

