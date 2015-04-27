class MembershipSerializer < ActiveModel::Serializer
  attributes \
    :id,
    :group_id,
    :role,
    :user_avatar_url,
    :user_full_name,
    :user_title
end
