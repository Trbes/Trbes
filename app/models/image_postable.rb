class ImagePostable < ActiveRecord::Base
  has_one :post, as: :postable
  has_many :attachments, as: :attachable

  accepts_nested_attributes_for :attachments

  def preview_image
    attachments.first.image
  end
end
