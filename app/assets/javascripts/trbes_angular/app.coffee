@trbes = angular.module('Trbes', [
  'ui.router'
  'templates'
  'ngSanitize'
  'ngResource'
  'ngRoute'
  'ngAnimate'
  'Devise'
  'angularMoment'
  'ui.bootstrap'
])

@trbes.config([
  '$stateProvider'
  '$urlRouterProvider'
  '$locationProvider'
  ($stateProvider, $urlRouterProvider, $locationProvider) ->
    $stateProvider.state('post_listing',
      url: '/'
      templateUrl: '/assets/trbes_angular/groups/_show.html'
      controller: 'GroupsCtrl'
    )
    $locationProvider.html5Mode(true)
    $urlRouterProvider.otherwise '/'
])

@trbes.directive('ngBindAttrs', ->
  (scope, element, attrs) ->
    scope.$watch attrs.ngBindAttrs, ((value) ->
      angular.forEach value, (value, key) ->
        attrs.$set key, value
    ), true
)

@trbes.directive('onLastRepeat', ['$timeout', ($timeout) ->
  (scope, element, attrs) ->
    if scope.$last
      $timeout (->
        scope.$emit 'onRepeatLast', element, attrs
        return
      ), 1
    return
])

@trbes.filter('htmlToPlaintext', ->
  (text) ->
    String(text).replace /<[^>]+>/gm, ''
)

@trbes.factory('Post', [
  '$resource'
  ($resource) ->
    $resource '/v1/posts/:id.json', null,
      all:
        url: '/v1/posts.json'
        method: 'GET'
        isArray: true
      upvote:
        url: '/v1/posts/:id/upvote.json'
        method: 'PUT'
      unvote:
        url: '/v1/posts/:id/unvote.json'
        method: 'PUT'
])

@trbes.factory('UsersHelper', ->
    sharedService = {}

    sharedService.user_popover_content = (membership) ->
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
      membership.role == "moderator" || membership.role == "owner"

    sharedService
)

root = exports ? this

root.initAuthentication = ($scope, Auth) ->
  $scope.userSignedIn = Auth.isAuthenticated
  Auth.currentUser().then (user) ->
    $scope.user = user
    console.log(user)
