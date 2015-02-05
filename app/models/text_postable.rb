class TextPostable < ActiveRecord::Base
  default_scope { includes(:attachments) }

  has_one :post, as: :postable
  has_many :attachments, as: :attachable

  validates :title, :body, presence: true
  validates :title, length: { minimum: 10, maximum: 100 }

  def preview_image
    attachments.first.image if attachments.any?
  end

  def content
    body
  end
end
