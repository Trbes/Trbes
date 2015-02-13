class DashboardController < ApplicationController
  expose(:group, attributes: :group_attributes)

  def index
  end

  def welcome
    authorize :dashboard, :welcome?
    render view_for_welcome
  end

  def invite
    authorize :dashboard, :invite?
    # Invite should only happen under the scope of a group
    redirect_to root_path unless current_group
  end

  def send_invitation
    authorize :dashboard, :send_invitation?

    SendInvitationEmailJob.new.async.perform(current_user.id, params[:group_id], params[:email_addresses])
    redirect_to root_path(subdomain: Group.find(params[:group_id]).subdomain),
      notice: t("invitation.success")
  end

  def create_group
    authorize :dashboard, :create_group?

    if group.save
      group.add_member(current_user, as: :owner)
      redirect_to invite_url(subdomain: group.subdomain)
    else
      render view_for_welcome
    end
  end

  private

  def view_for_welcome
    current_group ? "dashboard/welcome" : "dashboard/welcome_create_group"
  end

  def group_attributes
    params.require(:group).permit(
      :name, :description, :private, :subdomain,
      :allow_image_posts, :intended_usage)
  end
end
