class Membership < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  belongs_to :user, required: true, touch: true
  belongs_to :group, required: true, touch: true

  counter_culture :group,
    column_name: proc { |model| model.pending? ? nil : "memberships_count" },
    column_names: {
      ["memberships.role IN (0,1,2)"] => "memberships_count"
    }

  validates :user_id, uniqueness: { scope: :group_id }

  scope :for_group, -> (group) { where(group_id: group.id) }
  scope :not_owner, -> { where.not(role: roles[:owner]) }
  scope :not_member, -> { where.not(role: roles[:member]) }
  scope :not_pending, -> { where.not(role: roles[:pending]) }
  scope :not_blacklisted, -> { where.not(role: roles[:blacklisted]) }
  scope :confirmed, -> { where("users.confirmed_at IS NOT NULL") }
  scope :new_this_week, -> { where("created_at > ?", Date.today.beginning_of_week) }

  delegate :full_name, :avatar_url, :email, :title, to: :user, prefix: true
  delegate :name, to: :group, prefix: true

  enum role: %i(member moderator owner pending blacklisted)

  acts_as_paranoid

  attr_accessor :new_group_owner_id

  def posts_for_weekly_digest
    group.posts.for_weekly_digest
  end
end
