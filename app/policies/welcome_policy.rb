class WelcomePolicy < Struct.new(:membership, :welcome)
  def index?
    membership
  end

  def invite?
    membership.is_a?(Membership) && membership.owner?
  end

  def send_invitation?
    membership
  end

  def create_group?
    membership
  end
end
