class MembershipPolicy < Struct.new(:current_membership, :membership)
  def show_role_overlay?
    membership && (membership.moderator? || membership.owner?)
  end
end
