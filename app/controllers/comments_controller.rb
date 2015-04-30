class CommentsController < ApplicationController
  include Voting

  before_action(except: %i(upvote unvote)) { authorize(comment) }

  expose(:comment, attributes: :comment_attributes)
  expose(:post)

  def create
    result = CreateComment.call(
      membership: current_membership,
      post: post,
      attributes: comment_attributes,
      allow_publish: policy(Comment).publish?
    )

    redirect_to post_path(result.comment.post), flash: { notice: result.message }
  end

  def update
    flash[:notice] = if comment.update_attributes(comment_attributes)
      "Comment was successfully updated"
    else
      comment.errors.full_messages.join(". ")
    end

    comment.save

    redirect_to :back
  end

  def destroy
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
