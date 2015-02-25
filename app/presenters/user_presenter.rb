class UserPresenter < BasePresenter
  def join_partial_path(group)
    membership = @model.membership_for(group)
    if membership
      if membership.pending?
        "join_request_was_sent"
      else
        "enter"
      end
    else
      "join"
    end
  end
end
