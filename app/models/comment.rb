class Comment < ActiveRecord::Base
  belongs_to :post, counter_cache: :comments_count, required: true
  belongs_to :user, counter_cache: true, required: true

  validates :body, presence: true

  delegate :full_name, :title, :avatar, to: :user, prefix: true

  acts_as_votable

  scope :order_by_votes, -> { order(cached_votes_total: :desc) }
end
