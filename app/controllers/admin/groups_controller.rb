module Admin
  class GroupsController < Admin::ApplicationController
    expose(:group, attributes: :group_attributes) { view_context.present(current_group) }
    expose(:available_groups) do
      view_context.present(current_user.memberships.with_role(:admin).includes(:group).map(&:group))
    end

    def update
      group.update_attributes(group_attributes)

      respond_to do |format|
        format.html { render :edit }
        format.json { respond_with_bip(group) }
      end
    end

    def destroy
      group.destroy

      redirect_to new_group_path
    end

    private

    def group_attributes
      params.require(:group).permit(:name,
        :tagline,
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