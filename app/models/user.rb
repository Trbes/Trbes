class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships
  has_many :comments, dependent: :destroy
  has_many :profiles, dependent: :destroy

  has_one :avatar, as: :attachable, class_name: "Attachment"
  accepts_nested_attributes_for :avatar, update_only: true

  delegate :image, to: :avatar, prefix: true, allow_nil: true

  validates :full_name, presence: true

  devise :invitable, :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  acts_as_voter

  def membership_for(group)
    memberships.for_group(group).first
  end

  def avatar_url
    avatar_image.try(:thumbnail).try(:url) || "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}.png?d=mm"
  end

  def full_name
    super || email
  end

  def after_confirmation
    SendWelcomeEmailJob.perform_later(id)
  end
end
