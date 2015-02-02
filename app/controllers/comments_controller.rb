class CommentsController < ApplicationController
  expose(:comment, attributes: :comment_attributes)
  expose(:post)

  def create
    comment = CreateComment.call(
      user: current_user,
      post: post,
      attributes: comment_attributes
    ).comment

    redirect_to comment.post
  end

  def destroy
    comment.destroy

    redirect_to comment.post
  end

  private

  def comment_attributes
    params.require(:comment).permit(:body)
  end
end
