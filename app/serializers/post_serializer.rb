class PostSerializer < ActiveModel::Serializer
  attributes \
    :id,
    :slug,
    :created_at,
    :title,
    :post_type,
    :body,
    :link,
    :preview_image_url,
    :state,
    :editable,
    :published,
    :deleted,
    :voted_for,
    :share_link,
    :share_body,
    :tweet_intent,
    :path,
    :short_time_distance_string,
    :cached_votes_total,
    :comments_count

  has_one :membership
  has_many :attachments
  has_many :collection_posts

  delegate :current_group, to: :scope
  delegate :current_user, to: :scope

  def editable
    object.editable?
  end

  def published
    object.published?
  end

  def deleted
    object.deleted?
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

  def path
    scope.post_path(object)
  end

  def preview_image_url
    object.preview_image.try(:url)
  end

  def short_time_distance_string
    scope.short_time_distance_string(object.created_at)
  end

  def voted_for
    current_user.try(:voted_for?, object)
  end
end
