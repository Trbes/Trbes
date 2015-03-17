module CommentsHelper
  def comment_vote_path(comment, user)
    return "#" unless policy(comment).vote?(user)

    user.voted_up_on?(comment) ? comment_unvote_path(comment) : comment_upvote_path(comment)
  end
end
