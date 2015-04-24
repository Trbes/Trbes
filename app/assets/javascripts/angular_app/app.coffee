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

@trbes.directive('ngBindAttrs', ->
  (scope, element, attrs) ->
    scope.$watch attrs.ngBindAttrs, ((value) ->
      angular.forEach value, (value, key) ->
        attrs.$set key, value
    ), true
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
