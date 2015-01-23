class PostsController < ApplicationController
  expose(:post, attributes: :post_attributes)

  def new
  end

  def create
    result = PostCreator.call(
      attributes: post_attributes,
      current_group: current_group,
      current_user: current_user
    )

    if result.success?
      redirect_to(result.post, subdomain: current_group.subdomain)
    else
      render :new
    end
  end

  def show
  end

  private

  def post_attributes
    params.require(:post).permit(:postable_type, postable_attributes: %i(title link body))
  end
end
