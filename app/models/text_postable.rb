class TextPostable < ActiveRecord::Base
  has_one :post, as: :postable

  validates :title, :body, presence: true
  validates :title, length: { minimum: 10, maximum: 100 }
end
