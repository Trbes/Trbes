class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    profile = FindOrCreateProfile.call(auth_data: env["omniauth.auth"]).profile

    sign_in_and_redirect profile.user, event: :authentication
    set_flash_message(:notice, :success, kind: "#{profile.provider}".capitalize)
  end

  def facebook
    profile = FindOrCreateProfile.call(auth_data: env["omniauth.auth"]).profile

    sign_in_and_redirect profile.user, event: :authentication
    set_flash_message(:notice, :success, kind: "#{profile.provider}".capitalize)
  end

  def google_oauth2
    profile = FindOrCreateProfile.call(auth_data: env["omniauth.auth"]).profile

    sign_in_and_redirect profile.user, event: :authentication
    set_flash_message(:notice, :success, kind: "#{profile.provider}".capitalize)
  end
end
