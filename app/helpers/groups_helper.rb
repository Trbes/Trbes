module GroupsHelper
  def link_to_group(group)
    link_to(group.name, group_url(group))
  end

  def group_url(group)
    root_url(subdomain: group.subdomain)
  end

  def will_show_add_collection_hint?
    current_group.posts_count == 0 && current_group.collections_count == 0 && policy(Collection).create?
  end

  def will_show_collection_dropdown?
    policy(Collection).create? || current_group.collections.visible.count > Collection::VISIBLE_COLLECTIONS_COUNT
  end

  def will_show_group_cog_button?
    policy(:access).admin_access? || policy(:invitation).new?
  end

  def share_group_title(group)
    "JOIN #{group.name} on Trbes"
  end

  def share_group_body(group)
    [
      "Check out #{group.name} - A new place for us to share about #{group.tagline}",
      "#{group.description}",
      "Powered by Trbes.com"
    ].join("<center>&nbsp;</center>")
  end
end
