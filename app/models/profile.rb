class Profile < ActiveRecord::Base
  belongs_to :user

  validates :uid, :provider, presence: true
  validates :uid, uniqueness: { scope: :provider }

  def self.find_for_oauth(auth, user)
    profile = find_by(uid: auth.uid, provider: auth.provider)
    if profile.nil?
      user = User.new(
        full_name: auth.extra.raw_info.name,
        password: Devise.friendly_token[0,20],
        email: auth.email || "#{auth.info.nickname}@#{auth.provider}.com"
      )

      user.skip_confirmation!
      user.save!

      profile = create(uid: auth.uid, provider: auth.provider, user: user)
    end

    profile
  end
end
