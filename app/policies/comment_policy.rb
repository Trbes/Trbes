class CommentPolicy < Struct.new(:membership, :comment)
  def create?
    true
  end

  def destroy?
    comment.user == membership.user
  end
end
