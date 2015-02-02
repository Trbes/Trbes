class CommentPolicy < Struct.new(:membership, :comment)
  def create?
    membership.present?
  end

  def destroy?
    comment.user == membership.user
  end
end
