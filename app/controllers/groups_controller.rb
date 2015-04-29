class GroupsController < ApplicationController
  before_action :ensure_group_is_loaded!, :ensure_group_access_from_canonical_url!, only: [:show]

  expose(:group, attributes: :group_attributes)
  expose(:posts, only: [:show]) do
    scope = current_group.posts
      .includes(:attachments, collection_posts: :collection, membership: :user)
      .public_send(sort_filter)
      .page(params[:page])

    params[:collection_id] ? scope.for_collection(params[:collection_id]) : scope
  end

  expose(:current_group_collections) { current_group.collections.visible.ordered }
  expose(:collections_to_show) { current_group_collections[0..Collection::VISIBLE_COLLECTIONS_COUNT - 1] }
  expose(:hidden_collections) { current_group_collections[Collection::VISIBLE_COLLECTIONS_COUNT..-1] || [] }

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
    gon.group = GroupSerializer.new(current_group, root: false, scope: view_context)
    gon.membership = MembershipSerializer.new(current_membership, root: false, scope: view_context)
    gon.current_group_collections = current_group_collections
    gon.collections_to_show = collections_to_show
    gon.hidden_collections = hidden_collections
    gon.collection_icon_classes = Collection::FONT_AWESOME_ICONS[:web_application]
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
