module Admin
  class MembershipRolesController < Admin::ApplicationController
    expose(:membership_role, attributes: :membership_roles_attributes)

    def update
      UpdateMembershipRole.call(
        membership_role: membership_role,
        attributes: membership_roles_attributes
      )

      redirect_to edit_admin_group_path
    end

    private

    def membership_roles_attributes
      params.require(:membership_role).permit(:membership_id)
    end
  end
end
