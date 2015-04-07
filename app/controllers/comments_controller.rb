class CommentsController < ApplicationController
  include Voting

  expose(:comment, attributes: :comment_attributes)
  expose(:post)

  def create
    result = CreateComment.call(
      user: current_user,
      post: post,
      attributes: comment_attributes,
      allow_publish: policy(Comment).publish?
    )

    redirect_to post_path(result.comment.post), flash: { success: result.message }
  end

  def update
    authorize(comment)

    comment.save

    redirect_to :back
  end

  def destroy
    authorize(comment)

    comment.destroy

    redirect_to :back
  end

  private

  def comment_attributes
    # TODO: Encapsulate this into voting.rb somehow
    return if %w(upvote unvote).include?(action_name)

    params.require(:comment).permit(:body, :parent_comment_id)
  end
end
