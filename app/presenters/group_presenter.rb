class GroupPresenter < BasePresenter
  PRIVACY_TYPES = {
    true => "private",
    false => "public"
  }
  def memberships_count_link
    h.link_to h.pluralize(@model.memberships_count, "member"), h.admin_memberships_url(subdomain: @model.subdomain)
  end

  def memberships_count_modal_link
    h.link_to h.pluralize(@model.memberships_count, "member"), "#",
      data: { toggle: "modal", target: "#all_group_#{@model.id}_members" }
  end

  def posts_count_link
    h.link_to h.pluralize(@model.posts_count, "post"), h.group_url(@model)
  end

  def published_posts_count_link
    h.link_to h.pluralize(@model.published_posts_count, "post"), h.group_url(@model)
  end

  def privacy_type
    @model.private? ? "private" : "public"
  end

  def host
    "#{subdomain}.#{Trbes::Application.config.host}"
  end

  def pluralized_noun(noun, count)
    noun.pluralize(count)
  end

  def listing_logo
    tag_options = { class: "media-object group-logo" }

    logo_image_tag(tag_options)
  end

  def logo_image_tag(options = {})
    if @model.logo.present?
      h.cl_image_tag(@model.logo_url(:group_logo), options)
    else
      h.image_tag("sample/default-group.png", options.merge(width: 138))
    end
  end

  def privacy_class
    @model.private? ? "fa-lock" : "fa-unlock"
  end

  def privacy_text
    "Group is #{PRIVACY_TYPES[@model.private]}"
  end

  def join_partial_path(user)
    if user && membership = h.current_user_memberships.select { |m| m.group_id == @model.id }.first
      if membership.pending?
        "join_request_was_sent"
      else
        "enter"
      end
    else
      "join"
    end
  end

  def role_overlay(membership)
    return unless membership && (membership.moderator? || membership.owner?)

    h.content_tag(:span, membership.role.first, class: "role-overlay role-overlay-#{membership.role}")
  end

  def notifications_title
    h.pluralize(@model.notifications_count, "notification")
  end

  def pending_members_title
    h.pluralize(@model.memberships.pending.count, "pending member")
  end

  def pending_posts_title
    h.pluralize(@model.posts.moderation.count, "pending post")
  end

  def pending_comments_title
    h.pluralize(@model.comments.moderation.count, "pending comment")
  end
end
