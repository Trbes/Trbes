class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :memberships
  has_many :groups, through: :memberships

  validates :full_name, presence: true

  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable

  def membership_for(group)
    memberships.for_group(group).first
  end
end
