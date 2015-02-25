class UserPresenter < BasePresenter
  def join_partial_path(group)
    membership = @model.membership_for(group)
    if membership
      "#{membership.role}/join"
    else
      "join"
    end
  end
end
