module CommentsHelper
  def comment_vote_path(comment, user)
    return new_user_registration_path unless user_signed_in?
    return "#" unless policy(comment).vote?(user)

    user.voted_up_on?(comment) ? comment_unvote_path(comment) : comment_upvote_path(comment)
  end
end
