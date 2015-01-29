class CommentsController < ApplicationController
  expose(:comment, attributes: :comment_attributes)
  expose(:post)

  def create
    comment.user = current_user
    comment.post = post
    comment.save

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
