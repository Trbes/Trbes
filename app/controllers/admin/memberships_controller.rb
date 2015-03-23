module Admin
  class MembershipsController < Admin::ApplicationController
    expose(:membership, attributes: :membership_attributes)
    expose(:memberships, ancestor: :current_group) do |collection|
      collection = collection.public_send(params[:filter].to_sym) if params[:filter]
      collection.includes(user: :avatar).page(params[:page])
    end

    def update
      UpdateMembership.call(
        membership: membership,
        attributes: membership_attributes
      )

      respond_to do |format|
        format.html { redirect_to edit_admin_group_path }
        format.json { respond_with_bip(membership) }
      end
    end

    def destroy
      membership.destroy

      redirect_to admin_memberships_path
    end

    private

    def membership_attributes
      params.require(:membership).permit(:role, :new_group_owner_id)
    end
  end
end
