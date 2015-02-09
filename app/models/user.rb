class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships
  has_many :comments, dependent: :destroy

  has_one :attachment, as: :attachable

  validates :full_name, presence: true

  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable

  def membership_for(group)
    memberships.for_group(group).first
  end

  def avatar
    attachment || "https://placekitten.com/g/25/25"
  end
end
