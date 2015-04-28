@trbes.controller 'GroupsCtrl', [
  '$scope'
  '$routeParams'
  '$resource'
  '$timeout'
  '$modal'
  '$log'
  'Auth'
  'UsersHelper'
  'Authorizer'
  'POLICIES'
  'Post'
  ($scope, $routeParams, $resource, $timeout, $modal, $log, Auth, UsersHelper, Authorizer, POLICIES, Post) ->
    initAuthentication($scope, Auth)
    $scope.isBlank = isBlank
    $scope.group_id = gon.group_id
    $scope.membership = gon.membership
    $scope.POLICIES = POLICIES
    $scope.authorizer = new Authorizer($scope.membership)
    $scope.csrf_token = angular.element('meta[name="csrf-token"]').attr('content')

    Post.all().$promise.then (posts) ->
      $scope.posts = posts
      $scope.posts.forEach (post) ->
        console.log post if post.post_type == "image_post"
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

