@trbes.controller 'GroupsCtrl', [
  '$scope'
  '$routeParams'
  '$resource'
  '$timeout'
  '$modal'
  '$log'
  'Auth'
  ($scope, $routeParams, $resource, $timeout, $modal, $log, Auth) ->
    $scope.group_id = gon.group_id
]

