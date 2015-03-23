class MembershipsController < ApplicationController
  expose(:membership, attributes: :membership_attributes)

  # rubocop:disable Metrics/AbcSize
  # TODO: Move this logic to #create action
  def new
    redirect_to new_user_registration_url(subdomain: group.subdomain) and return unless user_signed_in?

    membership = Membership.new(group_id: current_group.id, user_id: current_user.id)

    if membership.save
      flash[:success] = t("app.membership.message.join.success")
    else
      flash[:error] = t("app.membership.message.join.error")
    end

    redirect_to params[:return_path] || "/"
  end
  # rubocop:enable Metrics/AbcSize

  def create
    membership.user = current_user
    membership.save

    redirect_to "/"
  end

  def destroy
    membership.destroy

    redirect_to "/"
  end

  private

  def membership_attributes
    params.require(:membership).permit(:group_id)
  end
end
