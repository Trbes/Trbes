module Admin
  class GroupsController < ApplicationController
    expose(:group, attributes: :group_attributes) { view_context.present(current_group) }

    def edit
      authorize :admin_dashboard, :index?
    end

    def update
      authorize :admin_dashboard, :index?

      group.update_attributes(attributes)

      render :edit
    end

    private

    def group_attributes
      params.require(:group).permit(:name, :headline, :description, :private, :subdomain, logo_attributes: :image)
    end
  end
end
