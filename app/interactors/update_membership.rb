class UpdateMembership
  include Interactor

  def call
    update_membership
  end

  private

  def update_membership
    if id = attributes[:new_group_owner_id]
      Membership.find(id).owner!
    end

    context.membership.update_attributes(attributes)
  end


  def attributes
    context.attributes
  end
end
