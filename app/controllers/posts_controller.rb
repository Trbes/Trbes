class PostsController < ApplicationController
  expose(:post, attributes: :post_attributes, finder: :find_by_slug)

  def new
  end

  def create
    result = CreatePost.call(
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
    params.require(:post).permit(
      :postable_type,
      postable_attributes: [
        :title,
        :link,
        :body,
        attachments_attributes: [:image]
      ]
    )
  end
end
