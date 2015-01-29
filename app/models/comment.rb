class Comment < ActiveRecord::Base
  belongs_to :post, counter_cache: true, required: true
  belongs_to :user, counter_cache: true, required: true

  validates :body, presence: true

  delegate :full_name, to: :user, prefix: true
end
