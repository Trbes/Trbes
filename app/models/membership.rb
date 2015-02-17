class Membership < ActiveRecord::Base
  belongs_to :user, required: true
  belongs_to :group, counter_cache: true, required: true

  scope :for_group, -> (group) { where(group_id: group.id) }
  scope :not_owner, -> { where.not(role: roles[:owner]) }
  scope :not_member, -> { where.not(role: roles[:member]) }
  scope :pending, -> { where(nil) } # TODO
  scope :new_this_week, -> { where(nil) } # TODO

  delegate :full_name, :avatar, to: :user

  enum role: %i(member moderator owner)

  attr_accessor :new_group_owner_id
end
