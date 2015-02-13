class InvitationPolicy < Struct.new(:membership, :invitation)
  def new?
    membership.is_a?(Membership) && membership.owner?
  end

  def create?
    membership.is_a?(Membership) && membership.owner?
  end
end
