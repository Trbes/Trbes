class MembershipsController < ApplicationController
  expose(:membership, attributes: :membership_attributes)

  # rubocop:disable Metrics/AbcSize
  def new
    redirect_to new_user_registration_url(subdomain: group.subdomain) and return unless user_signed_in?
    redirect_to "/" and return if current_user.membership_for(current_group).present?

    membership = Membership.new(group_id: current_group.id, user_id: current_user.id)
    membership.save

    flash.keep
    redirect_to "/", flash: { success: t("app.membership.message.join.success") }
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
