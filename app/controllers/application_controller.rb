class ApplicationController < ActionController::Base
  include Pundit

  respond_to :html

  protect_from_forgery

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  before_filter :load_current_membership

  expose(:groups)

  helper_method :current_group
  def current_group
    @current_group ||= Group.find_by(subdomain: request.subdomain)
  end

  def current_membership
    @current_membership ||= FindOrCreateMembership.call(user: current_user, group: current_group).membership
  end

  def ensure_group_is_loaded!
    return if current_group.present?

    render text: "Not found group for this subdomain", status: 404
  end

  protected

  def load_current_membership
    current_membership
  end

  def not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def pundit_user
    current_membership
  end

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
