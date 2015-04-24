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

  def extra_memberships_count
    memberships_count - Group::VISIBLE_MEMBERS_COUNT
  end

  def show_notifications_badge?(current_path)
    !current_path.include?("admin") && notifications_count > 0
  end

  def show_extra_memberships?
    memberships_count > Group::VISIBLE_MEMBERS_COUNT
  end

  def notifications_badge(current_path, options = {})
    return unless show_notifications_badge?(current_path)

    h.content_tag(:span, class: "badge notifications-count #{options[:extra_classes]}", title: notifications_title) do
      notifications_count.to_s
    end
  end
end
