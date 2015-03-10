module UsersHelper
  def user_popover_content(user)
    html = "<div class='user-popover-content'>"
    html += image_tag(user.avatar, class: "img-circle", width: 64, height: 64)
    html += "<div class='user-name'>#{user.full_name}</div>"
    html += "<div class='user-title'>#{user.title}</div>" if user.title.present?
    html += "</div>"

    html
  end

  def user_popover_template
    html = "<div class='popover popover-user' role='tooltip'>"
    html += "<div class='arrow'></div><h3 class='popover-title'></h3><div class='popover-content'></div>"
    html += "</div>"

    html
  end
end
