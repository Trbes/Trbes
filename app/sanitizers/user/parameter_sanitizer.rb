class User
  class ParameterSanitizer < Devise::ParameterSanitizer
    USER_PARAMS = %i(
      email
      full_name
      title
      password
      password_confirmation
    )

    def sign_up
      default_params.permit(USER_PARAMS)
    end

    def account_update
      default_params.permit(USER_PARAMS, :current_password, avatar_attributes: :image )
    end

    def accept_invitation
      default_params.permit(USER_PARAMS, :invitation_token)
    end
  end
end
