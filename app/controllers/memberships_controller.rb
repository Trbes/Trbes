class MembershipsController < ApplicationController
  expose(:membership, attributes: :membership_attributes)

  # rubocop:disable Metrics/AbcSize
  def create
    membership.group = current_group
    membership.user = current_user
    membership.save

    if membership.save
      flash[:success] = t("app.membership.message.join.success")
    else
      flash[:error] = t("app.membership.message.join.error")
    end

    redirect_to params[:return_path] || "/"
  end
  # rubocop:enable Metrics/AbcSize

  def destroy
    membership.destroy

    redirect_to "/"
  end

  private

  def membership_attributes
    params.require(:membership).permit(:group_id) if request.path != "/join"
  end
end
