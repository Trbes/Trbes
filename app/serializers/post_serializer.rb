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
    :cached_votes_total,
    :comments_count

end
