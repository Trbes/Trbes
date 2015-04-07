class UpdateMembership
  include Interactor

  def call
    update_membership
  end

  private

  def update_membership
    membership.update_attributes(attributes)

    SendRoleChangedEmailJob.perform_later(membership.id)

    role_specific_updater.call(context) if specific_actions_required?
  end

  def specific_actions_required?
    %w(moderator member).include?(membership.role)
  end

  def role_specific_updater
    "UpdateMembership::UpdateRoleTo#{membership.role.capitalize}".constantize
  end

  def attributes
    context.attributes
  end

  def membership
    context.membership
  end
end
