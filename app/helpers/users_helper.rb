module UsersHelper
  # rubocop:disable Metrics/AbcSize
  def user_popover_content(membership)
    html = "<div class=\'user-popover-content\'>"
    html += "<div class=\'user-role user-role-#{membership.role}\'>group #{membership.role}</div>"
    html += "<img src=\'#{membership.avatar_url}\' class=\'img-circle\' width=\'64\' height=\'64\'>"
    html += "<div class=\'user-name\'>#{membership.full_name}</div>"
    html += "<div class=\'user-title\'>#{membership.title}</div>" if membership.title.present?
    html += "</div>"

    html
  end
  # rubocop:enable Metrics/AbcSize

  def user_popover_template
    html = "<div class=\'popover popover-user\' role=\'tooltip\'>"
    html += "<div class=\'arrow\'></div><h3 class=\'popover-title\'></h3><div class=\'popover-content\'></div>"
    html += "</div>"

    html
  end
end
