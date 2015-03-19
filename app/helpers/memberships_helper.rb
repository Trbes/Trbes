module MembershipsHelper
  def membership_roles_options
    {}.tap do |options|
      (Membership.roles.keys << "all").reverse.each do |role|
        options["#{role.capitalize} (#{memberships.public_send(role).count})"] = role
      end
    end
  end
end
