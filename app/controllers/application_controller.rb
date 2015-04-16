class ApplicationController < ActionController::Base
  include Pundit

  has_mobile_fu false

  respond_to :html

  protect_from_forgery

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  before_action :push_algolia_config, :push_env_config, :push_indexes, :ensure_email_is_exists, :authorize_group_access

  expose(:groups)
  expose(:group_memberships) { current_group.memberships.joins(:user).confirmed.not_pending }

  helper_method :current_group
  def current_group
    @current_group = Group.where("custom_domain = ? OR subdomain = ?", request.host, request.subdomain)
      .includes(memberships: :user).first
  end

  helper_method :current_membership
  def current_membership
    return unless current_group && current_user

    @current_membership ||= current_user.membership_for(current_group)
  end

  def authorize_group_access
    authorize(current_group, :show?) if current_group
  end

  def ensure_group_access_from_canonical_url!
    return unless current_group
    return if request.host == current_group.custom_domain
    return if request.host.include?(Trbes::Application.config.host)

    redirect_to group_url(current_group)
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

    redirect_to(request.referrer || not_authorized_redirect)
  end

  def not_authorized_redirect
    current_group.private? ? root_url : root_path
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

  def push_algolia_config
    configuration = AlgoliaSearch.configuration
    configuration.merge!(
      group_scope_api_key_search: Algolia.generate_secured_api_key(
        ENV["ALGOLIASEARCH_API_KEY_SEARCH"],
        "(public,group_#{current_group.id})"
      ),
      group_tag: "group_#{current_group.id}"
    ) if current_group

    configuration.merge!(hosts: ALGOLIA_HOSTS) if defined?(ALGOLIA_HOSTS)

    gon.push(configuration)
  end

  def push_indexes
    gon.push(
      post_index: "Post_#{Rails.env}",
      group_index: "Group_#{Rails.env}"
    )
  end

  def push_env_config
    gon.push(facebook_app_id: ENV["FACEBOOK_APP_ID"])
  end

  def ensure_email_is_exists
    return unless current_user && current_user.email.ends_with?("twitter.com")
    render "devise/registrations/email_is_required"
  end

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end
end
