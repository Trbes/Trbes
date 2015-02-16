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

  def upvote
    comment.upvote_by(current_user)

    render json: {
      new_total_votes: comment.cached_votes_total
    }
  end

  private

  def comment_attributes
    params.require(:comment).permit(:body) if action_name != "upvote"
  end
end
