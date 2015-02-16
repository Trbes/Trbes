class GroupPolicy < Struct.new(:user, :group)
  def create?
    user
  end
end
