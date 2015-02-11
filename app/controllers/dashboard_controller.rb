class DashboardController < ApplicationController
  expose(:group, attributes: :group_attributes)

  def index
  end

  def welcome
    render view_for_welcome
  end

  def invite
    # Invite should only happen under the scope of a group
    unless user_signed_in? && current_group
      redirect_to root_path
      return
    end
  end

  def send_invitation
    unless user_signed_in?
      redirect_to root_path
      return
    end

    SendInvitationEmailJob.new.async.perform(current_user.id, params[:group_id], params[:email_addresses])
    redirect_to root_path(subdomain: Group.find(params[:group_id]).subdomain),
      notice: "Your invitation has been sent. Start exploring Trbes."
  end

  def create_group
    unless user_signed_in?
      redirect_to root_path
      return
    end

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
