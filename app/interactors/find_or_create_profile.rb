class FindOrCreateProfile
  include Interactor

  def call
    context.profile = find_profile || create_profile
  end

  private

  def find_profile
    Profile.find_by(uid: auth_data.uid, provider: auth_data.provider)
  end

  def create_profile
    user = User.new(
      full_name: auth_data.extra.raw_info.name,
      password: Devise.friendly_token[0,20],
      email: auth_data.info.email || "#{auth_data.info.nickname}@#{auth_data.provider}.com"
    )

    user.skip_confirmation!
    user.save!

    Profile.create(uid: auth_data.uid, provider: auth_data.provider, user: user)
  end

  def auth_data
    context.auth_data
  end
end
