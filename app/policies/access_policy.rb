# Use this policy only when there is no resources provided (a.k.a. headless policy)
class AccessPolicy < Struct.new(:membership, :owner)
  def admin_access?
    membership && (membership.owner? || membership.admin?)
  end
end
