class GroupsController < ApplicationController
  before_action :ensure_group_is_loaded!, only: [:show]

  expose(:group, attributes: :group_attributes)
  expose(:posts, only: [:show]) { current_group.posts.includes(:postable).order_by_votes }

  def new
  end

  def create
    if group.save
      redirect_to root_url(subdomain: group.subdomain)
    else
      render :new
    end
  end

  def show
  end

  private

  def group_attributes
    params.require(:group).permit(:name, :description, :private, :subdomain)
  end
end
