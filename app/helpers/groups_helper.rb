module GroupsHelper
  def link_to_group(group)
    link_to group.name, root_url(subdomain: group.subdomain)
  end
end
