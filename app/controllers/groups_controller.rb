class GroupsController < ApplicationController
  before_action :ensure_group_is_loaded!, :ensure_group_access_from_canonical_url!, only: [:show]

  expose(:group, attributes: :group_attributes)
  expose(:posts, only: [:show]) do
    scope = current_group.posts
      .published
      .includes(:attachments, membership: :user)
      .public_send(sort_filter)
      .page(params[:page])

    params[:collection_id] ? scope.includes(:collection_posts).for_collection(params[:collection_id]) : scope
  end

  expose(:group_owners) { Membership.owner.includes(:user, group: [memberships: :user]).joins(:group).where("groups.private = ?", false).page(params[:page]) }
  expose(:public_groups) { view_context.present(group_owners.map(&:group)) }
  expose(:public_groups_with_owners, only: [:index]) { public_groups.zip(group_owners) }

  expose(:current_user_memberships) { current_user.memberships }

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
    @group_name = current_group.name
    @group_tagline = current_group.tagline
    # So that search result click will redirects to group's url
    redirect_to root_url(subdomain: params[:id]) and return if params[:id]
  end

  private

  def sort_filter
    params[:sort] || "order_by_votes"
  end

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
      :image
    )
  end
end
