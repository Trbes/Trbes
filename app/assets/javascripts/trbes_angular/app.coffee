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
])

@trbes.config([
  '$stateProvider'
  '$urlRouterProvider'
  '$locationProvider'
  ($stateProvider, $urlRouterProvider, $locationProvider) ->
    $stateProvider.state('posts_listing',
      url: '/'
      templateUrl: 'groups/_show.html'
      controller: 'GroupsCtrl'
    )
    # $locationProvider.html5Mode(true)
    $urlRouterProvider.otherwise '/'
])

@trbes.filter('htmlToPlaintext', ->
  (input) ->
    if angular.isString(input) then input.replace(/<\S[^><]*>/g, '') else input
)
