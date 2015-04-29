class GroupSerializer < ActiveModel::Serializer
  attributes \
    :id,
    :name,
    :tagline,
    :description,
    :join_url

  def join_url
    scope.join_url(subdomain: object.subdomain)
  end
end
