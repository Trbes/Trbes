class UpdateRoleToOwner
  include Interactor

  def call
    change_owner
  end

  private

  def change_owner
    new_owner.owner!

    SendRoleChangedEmailJob.perform_later(new_owner.id)
  end

  def new_owner
    Membership.find(attributes[:new_group_owner_id])
  end
end
