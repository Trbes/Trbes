class WelcomeController < ApplicationController
  expose(:group, attributes: :group_attributes)

  def index
    authorize :welcome, :index?
    render view_for_welcome
  end

  def invite
    authorize :invitation, :new?
    # Invite should only happen under the scope of a group
    redirect_to root_path unless current_group
  end

  def send_invitation
    authorize :invitation, :create?

    SendInvitation.call(
      inviter: current_user,
      group: (group = Group.find(params[:group_id])),
      email_addresses: params[:email_addresses]
    )

    redirect_to root_path(subdomain: group.subdomain),
      notice: t("invitation.success")
  end

  def create_group
    authorize :welcome, :create_group?

    group = CreateGroup.call(
      user: current_user,
      attributes: group_attributes
    ).group

    if group.persisted?
      redirect_to invite_url(subdomain: group.subdomain)
    else
      render view_for_welcome
    end
  end

  private

  def pundit_user
    current_membership || current_user
  end

  def view_for_welcome
    current_group ? "welcome/welcome" : "welcome/welcome_create_group"
  end

  def group_attributes
    params.require(:group).permit(
      :name,
      :tagline,
      :description,
      :private,
      :subdomain,
      :allow_image_posts,
      :intended_usage,
      logo_attributes: :image
    )
  end
end
