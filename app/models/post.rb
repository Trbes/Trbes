class Post < ActiveRecord::Base
  include AlgoliaSearch
  extend FriendlyId

  POSTABLE_TYPES = %w(
    ImagePostable
    LinkPostable
    TextPostable
  ).freeze

  has_many :comments, dependent: :destroy
  belongs_to :group, required: true
  belongs_to :user, required: true
  belongs_to :postable, polymorphic: true, required: true

  delegate :title, :body, :link, :image, :preview_image, :attachments, :content, to: :postable
  delegate :full_name, to: :user, prefix: true

  scope :order_by_votes, -> { order(cached_votes_total: :desc) }

  accepts_nested_attributes_for :postable

  acts_as_votable

  paginates_per 20

  friendly_id :title, use: %i( slugged finders )

  algoliasearch do
    attribute :title, :content, :slug

    tags do
      ["group_#{group_id}"]
    end
  end
end
