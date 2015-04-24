@trbes.controller 'GroupsCtrl', [
  '$scope'
  '$routeParams'
  '$resource'
  '$timeout'
  '$modal'
  '$log'
  'Auth'
  'Post'
  ($scope, $routeParams, $resource, $timeout, $modal, $log, Auth, Post) ->
    initAuthentication($scope, Auth)
    $scope.group_id = gon.group_id

    Post.all().$promise.then (posts) ->
      $scope.posts = posts

]

