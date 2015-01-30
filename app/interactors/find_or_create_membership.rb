class FindOrCreateMembership
  include Interactor

  def call
    return unless user && group

    context.membership = find_membership || create_membership
  end

  private

  def find_membership
    user.membership_for(group)
  end

  def create_membership
    Membership.create!(user: user, group: group)
  end

  def user
    context.user
  end

  def group
    context.group
  end
end
