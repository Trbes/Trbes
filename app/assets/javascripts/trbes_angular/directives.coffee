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

@trbes.directive 'highlighter', [
  '$timeout'
  ($timeout) ->
    {
      restrict: 'A'
      scope: model: '=highlighter'
      link: (scope, element) ->
        scope.$watch 'model', (nv, ov) ->
          if nv != ov
            # apply class
            element.addClass 'highlight'
            # auto remove after some delay
            $timeout (->
              element.removeClass 'highlight'
              return
            ), 1000
          return
        return

    }
]
