class PostsController < ApplicationController
  expose(:post, attributes: :post_attributes, finder: :find_by_slug)
  expose(:comments, ancestor: :post) { |collection| collection.root.published.includes(:user, :child_comments) }

  def show
    self.post = Post.includes(user: :avatar).find_by(slug: params[:id])
  end

  def edit
    authorize(post)
  end

  def update
    authorize(post)

    post.save

    redirect_to :back
  end

  def create
    result = CreatePost.call(
      attributes: post_attributes,
      current_group: current_group,
      current_user: current_user,
      allow_publish: policy(Post).publish?)

    if result.success?
      redirect_to root_url(subdomain: current_group.subdomain), flash: { success: result.message }
    else
      render :new
    end
  end

  def destroy
    authorize(post)

    post.destroy

    redirect_to root_path
  end

  def upvote
    post.upvote_by(current_user)

    render json: {
      new_total_votes: post.cached_votes_total,
      voted_up: true,
      new_vote_path: post_unvote_path(post)
    }
  end

  def unvote
    post.unvote_by(current_user)

    render json: {
      new_total_votes: post.cached_votes_total,
      voted_up: false,
      new_vote_path: post_upvote_path(post)
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
    ) unless %w(upvote unvote).include?(action_name)
  end
end
