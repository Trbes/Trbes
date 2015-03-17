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

  def listing_logo
    tag_options = { class: "media-object group-logo" }

    logo_image_tag(tag_options)
  end

  def logo_image_tag(options = {})
    if @model.logo_image
      h.cl_image_tag(@model.logo_image.group_logo, options)
    else
      h.image_tag("sample/default-group.png", options)
    end
  end

  def privacy_class
    @model.private? ? "fa-unlock" : "fa-lock"
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

  def role_overlay(user)
    return unless (membership = user.membership_for(@model))
    return unless membership.moderator? || membership.owner?

    h.content_tag(:span, membership.role.first, class: "role-overlay role-overlay-#{membership.role}")
  end
end
