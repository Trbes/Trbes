class GroupPresenter < BasePresenter
  def memberships_count_link
    h.link_to h.pluralize(@model.memberships_count, "member"), "#"
  end

  def posts_count_link
    h.link_to h.pluralize(@model.posts_count, "post"), "#"
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

  def listing_logo
    tag_options = { class: "media-object group-logo", width: 138, height: 115 }
    if @model.logo_image
      h.cl_image_tag(@model.logo_image.logo, tag_options)
    else
      h.cl_image_tag("http://placekitten.com/g/138/115", tag_options)
    end
  end
end
