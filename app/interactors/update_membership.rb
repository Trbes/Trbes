class UpdateMembership
  include Interactor

  def call
    update_membership
  end

  private

  def update_membership
    if attributes[:new_group_owner_id]
      new_owner.owner!

      SendRoleChangedEmailJob.perform_later(new_owner.id)
    end

    context.membership.update_attributes(attributes)

    SendRoleChangedEmailJob.perform_later(context.membership.id)
  end

  def attributes
    context.attributes
  end

  def new_owner
    Membership.find(attributes[:new_group_owner_id])
  end
end
