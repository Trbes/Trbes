class UserSerializer < ActiveModel::Serializer
  attributes \
    :id,
    :full_name,
    :title,
    :email,
    :avatar
end
