module Admin
  class MembershipsController < Admin::ApplicationController
    expose(:membership, attributes: :membership_attributes)
    expose(:memberships, ancestor: :current_group) { |collection| collection.includes(:user) }

    def update
      UpdateMembership.call(
        membership: membership,
        attributes: membership_attributes
      )

      redirect_to edit_admin_group_path
    end

    private

    def membership_attributes
      params.require(:membership).permit(:role, :new_group_owner_id)
    end
  end
end
