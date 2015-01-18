class Post < ActiveRecord::Base
  belongs_to :group, required: true
  belongs_to :user, required: true

  validates :title, presence: true
end
