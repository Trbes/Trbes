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
  'truncate'
  'angular.filter'
  'ngInflection'
])

@trbes.config([
  '$stateProvider'
  '$urlRouterProvider'
  '$locationProvider'
  ($stateProvider, $urlRouterProvider, $locationProvider) ->
    if is_on_group_domain()
      $stateProvider.state('posts_listing',
        url: '/'
        templateUrl: 'groups/show.html'
        controller: 'GroupsCtrl'
      )
    else
      $stateProvider.state('groups_listing',
        url: '/'
        templateUrl: 'groups/index.html'
        controller: 'GroupsCtrl'
      )

    # $locationProvider.html5Mode(true)
    $urlRouterProvider.otherwise '/'
])

@trbes.filter('htmlToPlaintext', ->
  (input) ->
    if angular.isString(input) then input.replace(/<\S[^><]*>/g, '') else input
)
