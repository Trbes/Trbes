class CommentPresenter < BasePresenter
  def created_time_ago
    h.distance_of_time_in_words_to_now(@model.created_at)
  end
end
