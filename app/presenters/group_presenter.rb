class GroupPresenter < BasePresenter
  def memberships_count_link
    h.link_to h.pluralize(@model.memberships_count, "member"), h.admin_memberships_path
  end

  def privacy_type
    @model.private? ? "private" : "public"
  end

  def latest_posts
    posts.order_by_created_at.limit(4).includes(:user).map { |post| h.present(post) }
  end
end
