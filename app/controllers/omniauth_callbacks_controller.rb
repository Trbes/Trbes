class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    social_sign_in
  end

  def facebook
    social_sign_in
  end

  def google_oauth2
    social_sign_in
  end

  def linkedin
    social_sign_in
  end

  private

  def social_sign_in
    profile = FindOrCreateProfile.call(auth_data: env["omniauth.auth"]).profile

    sign_in_and_redirect profile.user, event: :authentication
    set_flash_message(:notice, :success, kind: "#{profile.provider}".capitalize)
  end
end
