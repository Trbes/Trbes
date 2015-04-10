class RegistrationsController < Devise::RegistrationsController
  skip_before_action :ensure_email_is_exists, only: [:update]

  def create
    super

    return unless resource.persisted? && (current_group = Group.find_by(subdomain: request.subdomain))

    current_group.add_member(resource, as: :pending)
  end

  protected

  def after_update_path_for(resource)
    edit_registration_path(resource)
  end

  def after_sign_up_path_for(_resource)
    welcome_path
  end

  def after_inactive_sign_up_path_for(resource)
    after_sign_up_path_for(resource)
  end

  def update_resource(resource, params)
    if params[:password].blank?
      params.delete(:current_password)
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end
end
