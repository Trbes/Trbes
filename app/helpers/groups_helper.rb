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
    # Rails.logger.debug "policy: #{policy(Collection).create?}, #{current_membership.id}"
    policy(Collection).create? || current_group.collections.visible.count > Collection::VISIBLE_COLLECTIONS_COUNT
  end
end
