class Post < ActiveRecord::Base
  POSTABLE_TYPES = %w(
    ImagePostable
    LinkPostable
    TextPostable
  ).freeze

  belongs_to :group, required: true
  belongs_to :user, required: true
  belongs_to :postable, polymorphic: true, required: true

  delegate :title, :body, :link, :image, :preview_image, to: :postable

  accepts_nested_attributes_for :postable

  acts_as_votable
end
