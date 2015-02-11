class DashboardController < ApplicationController

  expose(:group, attributes: :group_attributes)

  def index
  end

  def welcome
    render view_for_welcome
  end

  def invite
    # Invite should only happen under the scope of a group
    redirect_to root_path and return unless user_signed_in? && (group=Group.find_by_subdomain(params[:group]))

    @group_id = group.id
  end

  def send_invitation
    redirect_to root_path and return unless user_signed_in?

    SendInvitationEmailJob.new.async.perform(current_user.id, params[:group_id], params[:email_addresses])
    redirect_to root_path, notice: "Your invitation has been sent. Start exploring Trbes."
  end

  def create_group
    redirect_to root_path and return unless user_signed_in?

    if group.save
      group.add_member(current_user, as: :owner)
      redirect_to invite_path(group: group.subdomain)
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
