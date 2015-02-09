class AdminDashboardPolicy < Struct.new(:membership, :dashboard)
  def index?
    membership && membership.admin?
  end
end
