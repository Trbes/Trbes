class LinkPostable < ActiveRecord::Base
  has_one :post, as: :postable

  validates :link, presence: true

  def content
    link
  end
end
