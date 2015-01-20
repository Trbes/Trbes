class Post < ActiveRecord::Base
  POSTABLE_TYPES = %w(
    ImagePostable
    LinkPostable
    TextPostable
  ).freeze

  belongs_to :group, required: true
  belongs_to :user, required: true
  belongs_to :postable, polymorphic: true, required: true

  validates :title, presence: true
end
