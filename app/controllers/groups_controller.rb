class GroupsController < ApplicationController
  before_action :ensure_group_is_loaded!, only: [:show]

  expose(:group, attributes: :group_attributes)
  expose(:posts, only: [:show]) do
    scope = current_group.posts.includes(:attachments, :user).published.order_by_votes.page(params[:page])

    params[:collection_id] ? scope.includes(:collection_posts).for_collection(params[:collection_id]) : scope
  end
  expose(:public_groups, only: [:index]) do
    presented_groups = view_context.present(Group.all_public.includes(:logo).order_by_created_at)
    Kaminari.paginate_array(presented_groups).page(params[:page]).per(20)
  end

  def index
  end

  def new
  end

  def create
    authorize :group, :create?

    group = CreateGroup.call(
      user: current_user,
      attributes: group_attributes
    ).group

    redirect_to after_create_url(group) and return if group.persisted?

    # Temporary workaround for possible decent_exposure bug that clears group.errors in views
    @errors = group.errors
    render "new"
  end

  def show
    # So that search result click will redirects to group's url
    redirect_to root_url(subdomain: params[:id]) and return if params[:id]
  end

  private

  def pundit_user
    action_name == "create" ? current_user : current_membership
  end

  def after_create_url(group)
    params[:welcome] ? new_invitation_url(subdomain: group.subdomain) : group_url(group.subdomain)
  end

  def group_attributes
    params.require(:group).permit(
      :name,
      :tagline,
      :description,
      :private,
      :subdomain,
      :allow_image_posts,
      :intended_usage,
      logo_attributes: :image
    )
  end
end
