class GroupsController < ApplicationController
  before_action :ensure_group_is_loaded!, only: [:show]

  expose(:group, attributes: :group_attributes)
  expose(:post)
  expose(:posts, only: [:show]) do
    current_group.posts.includes(:attachments, :user).order_by_votes.page(params[:page])
  end

  def new
  end

  def create
    authorize :group, :create?

    group = CreateGroup.call(
      user: current_user,
      attributes: group_attributes
    ).group

    redirect_to after_create_url and return if group.persisted?

    # Temporary workaround for possible decent_exposure bug that clears group.errors in views
    @errors = group.errors
    render "new"
  end

  def show
    # So that search result click will redirects to group's url
    if params[:id]
      redirect_to root_url(subdomain: params[:id])
    end
  end

  private

  def pundit_user
    action_name == "create" ? current_user : current_membership
  end

  def after_create_url
    params[:welcome] ? new_invitation_url(subdomain: group.subdomain) : group_url(group)
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
