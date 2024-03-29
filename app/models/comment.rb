class Comment < ActiveRecord::Base
  include Postable

  belongs_to :post, counter_cache: :comments_count, required: true, touch: true
  belongs_to :membership, required: true
  belongs_to :parent_comment, class_name: "Comment", foreign_key: :parent_comment_id
  has_many :child_comments, class_name: "Comment", foreign_key: :parent_comment_id, dependent: :destroy

  validates :body, presence: true
  validates :body, length: { minimum: 5, maximum: 420 }

  normalize_attributes :body, with: %i( htmlize squish )

  delegate :user_full_name, :user_title, :user_avatar, :user_avatar_url, to: :membership

  acts_as_votable
  acts_as_paranoid

  scope :order_by_votes, -> { order(cached_votes_total: :desc) }
  scope :order_by_created_at, -> { order(created_at: :desc) }
  scope :root, -> { where(parent_comment_id: nil) }
  scope :favourite, -> { where(favourite: true) }
  scope :for_membership, -> (membership) { where(membership_id: membership.id) }
  scope :published_or_authored_by, lambda { |membership|
    where("state = ? OR membership_id = ?", states[:published], membership.id)
  }

  enum state: %i(moderation published rejected)

  def root?
    parent_comment_id.nil?
  end
end
