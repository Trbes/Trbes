class InvitationsController < Devise::InvitationsController
  skip_before_action :authorize_group_access, only: %i(edit update)

  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_group

  def new
    authorize :invitation, :new?
    @group_name = current_group.name
    # Invite should only happen under the scope of a group
    redirect_to root_path unless current_group
  end

  def create
    authorize :invitation, :create?

    SendInvitation.call(
      inviter: current_user,
      group: Group.find(params[:group_id]),
      email_addresses: params[:email_addresses]
    )

    head :ok
  end

  protected

  def current_group
    @current_group ||= (Group.find_by(custom_domain: request.host) ||
                        Group.find_by(subdomain: request.subdomain))
  end

  def pundit_user
    current_membership
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:accept_invitation).concat %i( full_name title invitation_token )
  end
end
