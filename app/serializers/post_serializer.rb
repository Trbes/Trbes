class PostSerializer < ActiveModel::Serializer
  attributes \
    :id,
    :slug,
    :created_at,
    :title,
    :post_type,
    :body,
    :link,
    :preview_image,
    :share_link,
    :share_body,
    :tweet_intent,
    :path,
    :image_tag,
    :short_time_distance_string,
    :cached_votes_total,
    :comments_count

  has_one :membership

  delegate :current_group, to: :scope

  def share_body
    scope.post_share_body(object)
  end

  def share_link
    scope.post_share_link(object)
  end

  def tweet_intent
    scope.post_tweet_intent(object)
  end

  def path
    scope.post_path(object)
  end

  def image_tag
    scope.cl_image_tag(object.preview_image)
  end

  def short_time_distance_string
    scope.short_time_distance_string(object.created_at)
  end
end
