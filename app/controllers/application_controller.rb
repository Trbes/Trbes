class ApplicationController < ActionController::Base
  include Pundit

  respond_to :html

  protect_from_forgery

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  before_action :load_current_membership, :push_algolio_config

  expose(:groups)

  helper_method :current_group
  def current_group
    @current_group ||= Group.find_by(subdomain: request.subdomain)
  end

  def current_membership
    @current_membership ||= FindOrCreateMembership.call(user: current_user, group: current_group).membership
  end

  def ensure_group_is_loaded!
    return if current_group.present? && !params[:subdomain]

    if params[:subdomain]
      redirect_to root_url(subdomain: params[:subdomain])
    else
      render text: "Not found group for this subdomain", status: 404
    end
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

  def push_algolio_config
    configuration = AlgoliaSearch.configuration

    if defined?(ALGOLIA_HOSTS)
      configuration.merge!(hosts: ALGOLIA_HOSTS)
    end

    gon.push(configuration)
  end

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end
end
