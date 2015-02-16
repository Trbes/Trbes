class MembershipPolicy < Struct.new(:membership)
  def manage_moderators?
    membership.owner?
  end
end
