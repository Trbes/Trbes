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
    $scope.group = gon.group
    $scope.membership = gon.membership
    $scope.current_group_collections = gon.current_group_collections
    $scope.POLICIES = POLICIES
    $scope.authorizer = new Authorizer($scope.membership)
    $scope.csrf_token = angular.element('meta[name="csrf-token"]').attr('content')
    $scope.posts = []
    $scope.current_page = 1
    $scope.total_posts_count = 1
    $scope.posts_per_page = 20
    $scope.max_size = 5 # number of pagination buttons
    $scope.UsersHelper = UsersHelper

    $scope.get_posts = (page) ->
      Post.all(page: page).$promise.then (response) ->
        $scope.posts = response.posts
        $scope.total_posts_count = response.total_posts_count

    $scope.$watch 'current_page', ->
      $scope.get_posts($scope.current_page)

    $scope.$on 'onRepeatLast', (scope, element, attrs) ->
      return if attrs.onLastRepeat != "posts"
      $timeout ->
        iconify_links()
        window.init_share_link_events()
        gsdk.initPopovers()
      , 1

    $scope.upvote_post = (post)->
      Post.upvote({id: post.id}, post).$promise.then (p) ->
        angular.copy(p, post)

    $scope.unvote_post = (post)->
      Post.unvote({id: post.id}, post).$promise.then (p) ->
        angular.copy(p, post)
]

