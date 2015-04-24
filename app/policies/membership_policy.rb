class MembershipPolicy < Struct.new(:current_membership, :membership)
  def show_role_overlay?
    membership && (membership.moderator? || membership.owner?)
  end

  def transfer_ownership?
    current_membership.owner?
  end

  def manage_moderators?
    current_membership.owner?
  end
end
