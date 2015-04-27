class PostSerializer < ActiveModel::Serializer
  attributes \
    :id,
    :slug,
    :created_at,
    :title,
    :post_type,
    :body,
    :link,
    :membership_id,
    :preview_image,
    :share_link,
    :share_body,
    :tweet_intent,
    :cached_votes_total,
    :comments_count

  delegate :current_group, to: :scope

  def preview_image
    object.preview_image
  end

  def share_body
    scope.post_share_body(object)
  end

  def share_link
    scope.post_share_link(object)
  end

  def tweet_intent
    scope.post_tweet_intent(object)
  end
end
