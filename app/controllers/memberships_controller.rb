class MembershipsController < ApplicationController
  expose(:membership, attributes: :membership_attributes)

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
