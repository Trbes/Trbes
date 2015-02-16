class Membership < ActiveRecord::Base
  belongs_to :user, required: true
  belongs_to :group, counter_cache: true, required: true

  has_many :membership_roles, dependent: :destroy
  has_many :roles, through: :membership_roles, dependent: :destroy

  scope :for_group, -> (group) { where(group_id: group.id) }
  scope :with_role, ->(role_name) { joins(:roles).where(roles: { name: role_name }) }
  scope :pending, -> { where(nil) } # TODO
  scope :new_this_week, -> { where(nil) } # TODO

  delegate :full_name, :avatar, to: :user

  def owner_membership_role
    membership_roles.where(role: Role.owner).first
  end

  def make_admin!
    roles << Role.admin
  end

  def make_owner!
    roles << Role.owner
  end

  def remove_owner
    roles.delete(Role.owner)
  end

  def admin?
    role?(:admin)
  end

  def owner?
    role?(:owner)
  end

  def moderator?
    role?(:moderator)
  end

  def role?(role)
    role_names = roles.collect(&:name)

    role_names.include?(role.to_s)
  end
end
