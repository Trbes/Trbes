# Use this policy only when there is no resources provided (a.k.a. headless policy)
class AccessPolicy < Struct.new(:membership, :admin)
  def admin?
    membership && membership.admin?
  end
end
