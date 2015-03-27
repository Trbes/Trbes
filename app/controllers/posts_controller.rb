class PostsController < ApplicationController
  include Voting

  expose(:post, attributes: :post_attributes, finder: :find_by_slug)
  expose(:comments, ancestor: :post) { |collection| collection.root.published.includes(:user, :child_comments) }

  def show
    self.post = Post.includes(user: :avatar).find_by(slug: params[:id])
    @post_title = post.title
    @group_name = current_group.name
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

  private

  def post_attributes
    # TODO: Encapsulate this into voting.rb somehow
    return if %w(upvote unvote).include?(action_name)

    params.require(:post).permit(
      :title,
      :body,
      :link,
      :post_type,
      attachments_attributes: %i( image id )
    )
  end
end
