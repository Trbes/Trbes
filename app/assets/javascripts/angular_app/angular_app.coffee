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
