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
    user = CreateUserFromOauth.call(auth_data: auth_data).user

    Profile.create(uid: auth_data.uid, provider: auth_data.provider, user: user)
  end

  def auth_data
    context.auth_data
  end
end
