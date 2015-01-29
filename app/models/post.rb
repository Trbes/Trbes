class Post < ActiveRecord::Base
  POSTABLE_TYPES = %w(
    ImagePostable
    LinkPostable
    TextPostable
  ).freeze

  has_many :comments, dependent: :destroy
  belongs_to :group, required: true
  belongs_to :user, required: true
  belongs_to :postable, polymorphic: true, required: true

  delegate :title, :body, :link, :image, :preview_image, to: :postable

  scope :order_by_votes, -> { order(cached_votes_total: :desc) }

  accepts_nested_attributes_for :postable

  acts_as_votable
end
