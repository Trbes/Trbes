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
      templateUrl: 'groups/_show.html'
      controller: 'GroupsCtrl'
    )
    # $locationProvider.html5Mode(true)
    $urlRouterProvider.otherwise '/'
])

@trbes.filter('htmlToPlaintext', ->
  (text) ->
    String(text).replace /<[^>]+>/gm, ''
)
