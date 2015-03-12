class FindOrCreateUserFromOauth
  include Interactor

  def call
    context.user = find_user || create_user
  end

  private

  def find_user
    User.find_by(email: auth_data.info.email)
  end

  def create_user
    user = User.new(send("#{auth_data.provider}_attributes"))

    user.skip_confirmation!
    user.save!

    user
  end

  def shared_attributes
    {
      full_name: auth_data.extra.raw_info.name,
      password: Devise.friendly_token[0, 20]
    }
  end

  def linkedin_attributes
    shared_attributes.merge(
      email: auth_data.info.email,
      full_name: auth_data.info.name
    )
  end

  def google_oauth2_attributes
    shared_attributes.merge(email: auth_data.info.email)
  end

  def facebook_attributes
    shared_attributes.merge(email: auth_data.info.email)
  end

  def twitter_attributes
    shared_attributes.merge(email: "#{auth_data.info.nickname}@#{auth_data.provider}.com")
  end

  def auth_data
    context.auth_data
  end
end
