class LinkPostable < ActiveRecord::Base
  has_one :post, as: :postable

  validates :link, presence: true

  def self.human_name
    'Link Post'
  end
end
