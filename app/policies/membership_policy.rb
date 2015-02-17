class MembershipPolicy < Struct.new(:membership, :membership)
  def transfer_ownership?
    membership.owner?
  end

  def manage_moderators?
    membership.owner?
  end
end
