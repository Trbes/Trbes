class CommentsController < ApplicationController
  expose(:comment, attributes: :comment_attributes)
  expose(:post)

  def create
    comment = CreateComment.call(
      user: current_user,
      post: post,
      attributes: comment_attributes,
      allow_publish: policy(Comment).publish?
    ).comment

    redirect_to comment.post
  end

  def update
    comment.save

    redirect_to :back
  end

  def destroy
    comment.destroy

    redirect_to :back
  end

  def upvote
    comment.upvote_by(current_user)

    render json: {
      new_total_votes: comment.cached_votes_total,
      voted_up: true,
      new_vote_path: comment_unvote_path(comment)
    }
  end

  def unvote
    comment.unvote_by(current_user)

    render json: {
      new_total_votes: comment.cached_votes_total,
      voted_up: false,
      new_vote_path: comment_upvote_path(comment)
    }
  end

  private

  def comment_attributes
    params.require(:comment).permit(:body, :parent_comment_id) unless %w(upvote unvote).include?(action_name)
  end
end
