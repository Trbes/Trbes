module V1
  class GroupsController < V1::ApiController
    expose(:group_owners) do
      Membership
        .owner
        .includes(:user, :group)
        .joins(:group)
        .where("groups.private = ?", false)
        .order("groups.created_at DESC")
        .page(params[:page]).per(10)
    end

    expose(:public_groups) { view_context.present(group_owners.map(&:group)) }

    expose(:public_groups_with_owners, only: [:index]) do
      public_groups.zip(group_owners)
    end

    def index
      render json: {
        groups: public_groups_with_owners.map { |group, owner| GroupSerializer.new(group, root: false, scope: view_context) },
        total_count: group_owners.total_count
      }
    end

    private

    def pundit_user
      action_name == "create" ? current_user : current_membership
    end
  end
end
