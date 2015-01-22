class TextPostable < ActiveRecord::Base
  has_one :post, as: :postable

  validates :title, :body, presence: true

  def self.human_name
    'Text Post'
  end
end
