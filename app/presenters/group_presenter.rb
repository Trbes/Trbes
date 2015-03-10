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

  def host
    "#{subdomain}.trbes.com"
  end

  def pluralized_noun(noun)
    noun.pluralize(@model.memberships_count)
  end

  def preview_logo
    tag_options = { width: 138, height: 115 }

    logo_image_tag(tag_options)
  end

  def listing_logo
    tag_options = { class: "media-object group-logo", width: 138, height: 115 }

    logo_image_tag(tag_options)
  end

  def logo_image_tag(options)
    if @model.logo_image
      h.cl_image_tag(@model.logo_image.logo, options)
    else
      h.image_tag("sample/default-group.png", options)
    end
  end

  def join_partial_path(user)
    if user && user.membership_for(@model)
      if user.membership_for(@model).pending?
        "join_request_was_sent"
      else
        "enter"
      end
    else
      "join"
    end
  end
end
