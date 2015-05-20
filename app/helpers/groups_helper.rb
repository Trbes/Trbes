module GroupsHelper
  def link_to_group(group)
    link_to(group.name, group_url(group))
  end

  def group_url(group)
    if group.custom_domain.present?
      group_custom_domain_url(group)
    else
      root_url(subdomain: group.subdomain)
    end[0..-2] # remove trailing slash
  end

  def group_join_url(group)
    "#{group_url(group)}#{join_path}"
  end

  def will_show_add_collection_hint?
    current_group.published_posts_count > 0 && current_group.collections_count == 0 && policy(Collection).create?
  end

  def will_show_collection_dropdown?
    policy(Collection).create? || current_group.collections.visible.count > Collection::VISIBLE_COLLECTIONS_COUNT
  end

  def group_share_title(group)
    "JOIN #{group.name} on Trbes"
  end

  def group_logo_url(group)
    if group.logo.present?
      group.logo_url(:group_logo)
    else
      image_url("sample/default-group.png")
    end
  end

  def group_share_body(group)
    [
      "Check out #{group.name} - A new place for us to share about #{group.tagline}",
      "#{group.description}",
      "Powered by Trbes.com"
    ].join("<center>&nbsp;</center>")
  end

  def group_tweet_intent(group)
    opts = {
      text: "JOIN #{group.name} - A new place to share about #{group.tagline}",
      url: group_join_url(group),
      via: "trbesapp"
    }

    tweet_intent(opts)
  end

  private

  def group_custom_domain_url(group)
    root_url(host: group.custom_domain)
  end
end
