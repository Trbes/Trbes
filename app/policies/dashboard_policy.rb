class DashboardPolicy < Struct.new(:membership, :user, :dashboard)
  def invite?
    membership && membership.owner?
  end

  def welcome?
    user
  end

  def send_invitation?
    membership
  end

  def create_group?
    user
  end
end
