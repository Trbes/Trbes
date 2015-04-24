class V1::PostsController < V1::ApiController
  expose(:posts)
  expose(:post, attributes: :post_attributes)
  expose(:comments, ancestor: :post) { |collection| collection.root.published.includes(:membership, :child_comments) }

  def edit
    authorize(post)
  end

  def update
    authorize(post)

    if post.save
      render json: post
    else
      render json: { error: true, messages: post.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize(post)

    post.destroy

    head :ok
  end

  def upvote
    post.upvote_by(current_user)

    render json: post
  end

  def unvote
    resource.unvote_by(current_user)

    render json: post
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
