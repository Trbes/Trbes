class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships
  has_many :comments, dependent: :destroy
  has_many :profiles, dependent: :destroy

  validates :full_name, presence: true

  devise :invitable, :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  acts_as_voter

  mount_uploader :avatar, ImageUploader

  def membership_for(group)
    memberships.for_group(group).first
  end

  def avatar_url
    avatar.thumbnail.url || "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}.png?d=mm"
  end

  def full_name
    super || email
  end

  def after_confirmation
    SendWelcomeEmailJob.perform_later(id)
  end

  after_create do
    if ENV["TRBES_GROUP_ID"].present?
      trbes_group = Group.find ENV["TRBES_GROUP_ID"]
      trbes_group.add_member(self, as: :member)
    end
  end
end
