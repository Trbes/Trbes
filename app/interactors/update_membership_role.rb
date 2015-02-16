class UpdateMembershipRole
  include Interactor

  def call
    update_membership_role
  end

  private

  def update_membership_role
    if membership_role.membership.membership_roles == [membership_role]
      membership_role.membership.make_member!
    end

    membership_role.update_attributes(attributes)
  end

  def membership_role
    context.membership_role
  end

  def attributes
    context.attributes
  end
end
