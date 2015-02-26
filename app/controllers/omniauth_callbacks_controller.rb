class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    profile = Profile.find_for_oauth(env["omniauth.auth"], current_user)

    sign_in_and_redirect profile.user, event: :authentication
    set_flash_message(:notice, :success, kind: "#{profile.provider}".capitalize)
  end
end
