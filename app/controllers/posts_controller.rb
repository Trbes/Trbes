class PostsController < ApplicationController
  expose(:post, attributes: :post_attributes, finder: :find_by_slug)
  expose(:comments, ancestor: :post) { |collection| collection.root.published }

  def new
  end

  def create
    result = CreatePost.call(
      attributes: post_attributes,
      current_group: current_group,
      current_user: current_user,
      allow_publish: policy(Post).publish?)

    if result.success?
      redirect_to(result.post, subdomain: current_group.subdomain)
    else
      render :new
    end
  end

  def show
  end

  def upvote
    post.upvote_by(current_user)

    render json: {
      new_total_votes: post.cached_votes_total
    }
  end

  private

  def post_attributes
    params.require(:post).permit(
      :title,
      :body,
      :link,
      :post_type,
      attachments_attributes: [:image]
    ) if action_name != "upvote"
  end
end
