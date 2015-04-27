@trbes.controller 'GroupsCtrl', [
  '$scope'
  '$routeParams'
  '$resource'
  '$timeout'
  '$modal'
  '$log'
  'Auth'
  'UsersHelper'
  'Post'
  ($scope, $routeParams, $resource, $timeout, $modal, $log, Auth, UsersHelper, Post) ->
    initAuthentication($scope, Auth)
    $scope.isBlank = isBlank
    $scope.group_id = gon.group_id

    Post.all().$promise.then (posts) ->
      $scope.posts = posts
      $scope.posts.forEach (post) ->
        post.membership.user_popover_content = UsersHelper.user_popover_content(post.membership)
        post.membership.user_popover_template = UsersHelper.user_popover_template()
        post.membership.show_role_overlay = UsersHelper.show_role_overlay(post.membership)

    $scope.$on 'onRepeatLast', (scope, element, attrs) ->
      return if attrs.onLastRepeat != "posts"
      $timeout ->
        iconify_links()
        window.init_share_link_events()
      , 1
]

