class RegistrationsController < Devise::RegistrationsController
  def create
    super

    return unless resource.persisted? && (current_group = Group.find_by(subdomain: request.subdomain))

    current_group.add_member(resource, as: :pending)
  end

  protected

  def after_sign_up_path_for(_resource)
    welcome_path
  end

  def after_inactive_sign_up_path_for(resource)
    after_sign_up_path_for(resource)
  end
end
