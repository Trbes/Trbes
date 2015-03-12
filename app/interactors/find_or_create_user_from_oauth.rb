class FindOrCreateUserFromOauth
  include Interactor

  def call
    context.user = find_user || create_user
  end

  private

  def find_user
    User.find_by(email: email_from_auth)
  end

  def create_user
    user = User.new(user_attributes)

    user.skip_confirmation!
    user.save!

    user
  end

  def user_attributes
    {
      full_name: auth_data.info.name,
      password: Devise.friendly_token[0, 20],
      email: email_from_auth
    }
  end

  def email_from_auth
    auth_data.info.email || "#{auth_data.info.nickname}@#{auth_data.provider}.com"
  end

  def auth_data
    context.auth_data
  end
end
