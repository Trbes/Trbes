module Admin
  class GroupsController < ApplicationController
    expose(:group, attributes: :group_attributes) { view_context.present(current_group) }

    def edit
      authorize :admin_dashboard, :index?
    end

    def update
      authorize :admin_dashboard, :index?

      group.update_attributes(group_attributes)

      respond_to do |format|
        format.html { render :edit }
        format.json { respond_with_bip(group) }
      end
    end

    def destroy
      authorize :admin_dashboard, :index?

      group.destroy

      redirect_to new_group_path
    end

    private

    def group_attributes
      params.require(:group).permit(
        :name,
        :headline,
        :description,
        :private,
        :subdomain,
        :allow_image_posts,
        :allow_link_posts,
        :allow_text_posts,
        logo_attributes: :image
      )
    end
  end
end
