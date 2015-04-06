class UpdateMembership
  include Interactor

  def call
    update_membership
  end

  private

  def update_membership
    context.membership.update_attributes(attributes)

    SendRoleChangedEmailJob.perform_later(context.membership.id)

    role_specific_updater.call(context) if Object.const_defined?(role_specific_updater.to_s)
  end

  def role_specific_updater
    "UpdateRoleTo#{context.membership.role.capitalize}".constantize
  end

  def attributes
    context.attributes
  end
end
