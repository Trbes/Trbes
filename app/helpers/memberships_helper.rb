module MembershipsHelper
  def membership_roles_options
    {}.tap do |options|
      (Membership.roles.keys << "all").reverse.each do |role|
        options["#{role.capitalize} (#{memberships.public_send(role).count})"] = role
      end
    end
  end

  def will_show_admin_members_button_count_badge?
    !controller_path.include?("admin/memberships") && current_group.memberships.pending.count > 0
  end
end
