class InvitationPolicy < Struct.new(:membership, :invitation)
  def new?
    membership && membership.owner?
  end

  def create?
    membership && membership.owner?
  end
end
