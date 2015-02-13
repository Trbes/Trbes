class DashboardPolicy < Struct.new(:membership, :dashboard)
  def invite?
    membership.is_a?(Membership) && membership.owner?
  end

  def welcome?
    membership
  end

  def send_invitation?
    membership
  end

  def create_group?
    membership
  end
end
