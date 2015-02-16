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

  Role::ALLOWED_ROLES.each do |role|
    define_method("make_#{role}!") do
      roles << Role.public_send(role)
    end

    define_method("remove_#{role}!") do
      roles.delete(Role.public_send(role))
    end

    define_method("#{role}?") do
      role?(role)
    end

    define_method("#{role}_membership_role") do
      membership_roles.where(role: Role.public_send(role)).first
    end
  end

  def moderator?
    role?(:moderator)
  end

  def role?(role)
    role_names = roles.collect(&:name)

    role_names.include?(role.to_s)
  end
end
