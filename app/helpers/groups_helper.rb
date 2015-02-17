module GroupsHelper
  def link_to_group(group)
    link_to(group.name, group_url(group))
  end

  def group_url(group)
    root_url(subdomain: group.subdomain)
  end

  def will_show_add_collection_hint?
    current_group.posts_count == 0 &&
      current_group.collections_count == 0 &&
      policy(Collection).new?
  end

  def will_show_collection_dropdown?
    current_group.collections.for_dropdown.count > 0 || policy(Collection).new?
  end
end
