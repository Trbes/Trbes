class Comment < ActiveRecord::Base
  belongs_to :post, counter_cache: :comments_count, required: true
  belongs_to :user, counter_cache: true, required: true
  belongs_to :parent_comment, class_name: "Comment", foreign_key: :parent_comment_id
  has_many :child_comments, class_name: "Comment", foreign_key: :parent_comment_id

  validates :body, presence: true

  delegate :full_name, :title, :avatar, to: :user, prefix: true

  acts_as_votable

  scope :order_by_votes, -> { order(cached_votes_total: :desc) }
  scope :root, -> { where(parent_comment_id: nil) }

  def root?
    parent_comment_id.nil?
  end
end
