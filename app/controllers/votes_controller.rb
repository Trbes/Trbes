class VotesController < ApplicationController
  expose(:post, finder_parameter: :vote_id)

  def upvote
    post.upvote_by(current_user)

    redirect_to :back
  end
end
