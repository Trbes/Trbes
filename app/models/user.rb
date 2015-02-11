class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships
  has_many :comments, dependent: :destroy

  has_one :avatar, as: :attachable, class_name: "Attachment"

  validates :full_name, presence: true

  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :invitation_code
  before_create :generate_invite_code

  def membership_for(group)
    memberships.for_group(group).first
  end

  def avatar
    self[:avatar] || "https://placekitten.com/g/25/25"
  end

  protected

  def generate_invite_code
    self.invite_code = loop do
      random_code = SecureRandom.urlsafe_base64(5)
      break random_code unless User.exists?(invite_code: random_code)
    end
  end
end
