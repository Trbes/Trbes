class PostPolicy < Struct.new(:membership, :post)
  def publish?
    membership && (membership.owner? || membership.moderator? || membership.member?)
  end
end
