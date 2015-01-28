class ImagePostable < ActiveRecord::Base
  default_scope { includes(:attachments) }

  has_one :post, as: :postable
  has_many :attachments, as: :attachable

  accepts_nested_attributes_for :attachments

  def preview_image
    attachments.first.image if attachments.any?
  end
end
