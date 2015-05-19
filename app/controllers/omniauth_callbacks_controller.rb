class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :social_sign_in

  def twitter; end

  def facebook; end

  def google_oauth2; end

  def linkedin; end

  private

  def social_sign_in
    profile = FindOrCreateProfile.call(auth_data: env["omniauth.auth"]).profile

    sign_in_and_redirect profile.user, event: :authentication
    set_flash_message(:notice, :success, kind: "#{profile.provider}".capitalize)
  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'].gsub("/users/sign_in", "")
  end
end
