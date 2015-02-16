class GroupPresenter < BasePresenter
  def memberships_count_link
    h.link_to h.pluralize(@model.memberships_count, "member"), "#"
  end

  def privacy_type
    @model.private? ? "private" : "public"
  end

  def latest_posts
    posts.order_by_created_at.limit(4).includes(:user).map { |post| h.present(post) }
  end

  def host
    "#{subdomain}.trbes.com"
  end

  def pluralized_noun(noun)
    noun.pluralize(@model.memberships_count)
  end

  def preview_logo
    @model.logo_image ? h.cl_image_tag(@model.logo_image.logo) : h.cl_image_tag("http://placekitten.com/g/101/101")
  end
end
