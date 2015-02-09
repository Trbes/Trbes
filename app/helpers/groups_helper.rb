module GroupsHelper
  def link_to_group(group)
    link_to(group.name, group_url(group))
  end

  def group_url(group)
    root_url(subdomain: group.subdomain)
  end
end
