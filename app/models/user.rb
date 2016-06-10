class User < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :profiles, dependent: :destroy

  has_many :posts, through: :memberships
  has_many :comments, through: :memberships
  has_many :groups, through: :memberships

  validates :full_name, presence: true

  devise :invitable, :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  acts_as_voter
  acts_as_paranoid

  mount_uploader :avatar, ImageUploader

  mailkick_user

  def membership_for(group)
    memberships.select { |m| m.group_id == group.id }.first
  end

  def avatar_url
    avatar.thumbnail.url || "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}.png?d=mm"
  end

  def full_name
    super
  end

  def after_confirmation
    SendWelcomeEmailJob.perform_later(id)
  end

  def voted_for?(entity)
    votes.select { |vote| vote.votable_id == entity.id }.any?
  end

  def after_password_reset
  end

  after_create do
    if ENV["TRBES_GROUP_ID"].present?
      trbes_group = Group.find ENV["TRBES_GROUP_ID"]
      trbes_group.add_member(self, as: :member)
    end
  end
end
