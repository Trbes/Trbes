@trbes.controller 'PostsCtrl', [
  '$scope'
  '$routeParams'
  '$resource'
  '$timeout'
  '$modal'
  '$log'
  'Auth'
  ($scope, $routeParams, $resource, $timeout, $modal, $log, Auth) ->
    initAuthentication($scope, Auth)
]
