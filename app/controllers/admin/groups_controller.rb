module Admin
  class GroupsController < Admin::ApplicationController
    expose(:group, attributes: :group_attributes) { view_context.present(current_group) }
    expose(:memberships, ancestor: :current_group)
    expose(:available_groups) do
      view_context.present(current_user.memberships.not_member.includes(:group).map(&:group).compact)
    end

    def update
      authorize(group)

      group.update_attributes(group_attributes)

      redirect_to edit_admin_group_path
    end

    def destroy
      authorize(group)

      group.destroy

      redirect_to new_group_path
    end

    private

    def group_attributes # rubocop:disable Metrics/MethodLength
      params.require(:group).permit(
        :name,
        :tagline,
        :description,
        :private,
        :subdomain,
        :custom_domain,
        :allow_image_posts,
        :allow_link_posts,
        :allow_text_posts,
        :logo,
        :ga_tracking_id
      )
    end
  end
end
