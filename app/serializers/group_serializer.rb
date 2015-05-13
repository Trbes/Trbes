class GroupSerializer < ActiveModel::Serializer
  attributes \
    :id,
    :name,
    :tagline,
    :description,
    :join_url,
    :url,
    :logo_url,
    :join_partial_path,
    :current_membership_path,
    :memberships_count,
    :posts_count,
    :published_posts_count,
    :will_show_add_collection_hint,
    :will_show_collection_dropdown

  has_one :owner
  delegate :current_user, to: :scope

  def join_url
    scope.join_url(subdomain: object.subdomain)
  end

  def url
    scope.group_url(object)
  end

  def logo_url
    scope.group_logo_url(object)
  end

  def join_partial_path
    if current_user && current_user.membership_for(object)
      if current_user.membership_for(object).pending?
        "join_request_was_sent"
      else
        "enter"
      end
    else
      "join"
    end
  end

  def current_membership_path
    scope.membership_path(current_user.membership_for(object)) if current_user && current_user.membership_for(object)
  end

  def will_show_add_collection_hint
    object.posts_count == 0 && object.collections_count == 0 && scope.policy(Collection).create?
  end

  def will_show_collection_dropdown
    scope.policy(Collection).create? || object.collections.visible.count > Collection::VISIBLE_COLLECTIONS_COUNT
  end
end
