class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy

  validates :full_name, presence: true

  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable

  def to_s
    full_name
  end

  def full_name_with_email
    "#{self[:full_name]} (#{email})"
  end
end
