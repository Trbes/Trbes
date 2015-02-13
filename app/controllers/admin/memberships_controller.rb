module Admin
  class MembershipsController < Admin::ApplicationController
    expose(:membership)

    def make_owner
      membership.group.owner.remove_owner
      membership.make_owner!

      redirect_to :back
    end

    private

    def membership_attributes
      params.require(:membership)
    end
  end
end
