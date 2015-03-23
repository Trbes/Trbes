class Membership < ActiveRecord::Base
  belongs_to :user, required: true
  belongs_to :group, counter_cache: true, required: true

  scope :for_group, -> (group) { where(group_id: group.id) }
  scope :not_owner, -> { where.not(role: roles[:owner]) }
  scope :not_member, -> { where.not(role: roles[:member]) }
  scope :new_this_week, -> { where("created_at > ?", Date.today.beginning_of_week) }

  delegate :full_name, :avatar_url, to: :user

  enum role: %i(member moderator owner pending)

  attr_accessor :new_group_owner_id
end
