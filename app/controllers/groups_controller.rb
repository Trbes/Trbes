class GroupsController < ApplicationController
  before_action :ensure_group_is_loaded!, only: [:show]

  expose(:group, attributes: :group_attributes)
  expose(:posts, only: [:show]) do
    current_group.posts.includes(:postable, :user).order_by_votes.page(params[:page])
  end

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
