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
