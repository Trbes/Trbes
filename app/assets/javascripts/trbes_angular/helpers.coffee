root = exports ? this

root.init_authentication = ($scope, Auth) ->
  $scope.userSignedIn = Auth.isAuthenticated
  $scope.login_triggered = false
  Auth.currentUser().then (user) ->
    $scope.login_triggered = true
    $scope.user = user
  , (error) ->
    $scope.login_triggered = true

@trbes.factory('UsersHelper', ->
  sharedService = {}

  sharedService.user_popover_content = (membership) ->
    return if !membership

    html = "<div class=\'user-popover-content\'>"
    html += "<div class=\'user-role user-role-" + membership.role + "\'>group " + membership.role + "</div>"
    html += "<img src=\'" + membership.user_avatar_url + "\' class=\'img-circle\' width=\'64\' height=\'64\'>"
    html += "<div class=\'user-name\'>" + membership.user_full_name + "</div>"

    unless isBlank(membership.user_title)
      html += "<div class=\'user-title\'>" + membership.user_title + "</div>"

    html += "</div>"

    html

  sharedService.user_popover_template = ->
    html = "<div class=\'popover popover-user\' role=\'tooltip\'>"
    html += "<div class=\'arrow\'></div><h3 class=\'popover-title\'></h3><div class=\'popover-content\'></div>"
    html += "</div>"

    html

  sharedService.show_role_overlay = (membership) ->
    return false if !membership

    membership.role == "moderator" || membership.role == "owner"

  sharedService
)

root.is_on_group_domain = () ->
  host = window.location.hostname
  subdomain = host.indexOf('.') < 0 ? null : host.split('.')[0]
  console.log "host ", host, gon.trbes_host
  return subdomain || host != gon.trbes_host
