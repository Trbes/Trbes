class ApplicationController < ActionController::Base
  respond_to :html

  protect_from_forgery

  helper_method :current_group
  def current_group
    @current_group ||= Group.find_by(subdomain: request.subdomain)
  end

  def ensure_group_is_loaded!
    return if current_group.present?

    render text: 'Not found group for this subdomain', status: 404
  end

  protected

  def devise_parameter_sanitizer
    if resource_class == User
      User::ParameterSanitizer.new(User, :user, params)
    else
      super
    end
  end

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end
end
