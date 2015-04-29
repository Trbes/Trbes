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
    $scope.collections_to_show = gon.collections_to_show
    $scope.hidden_collections = gon.hidden_collections
    $scope.collection_icon_classes = gon.collection_icon_classes
    $scope.sample_icon_class = $scope.collection_icon_classes[Math.floor(Math.random()*$scope.collection_icon_classes.length)]
    $scope.POLICIES = POLICIES
    $scope.authorizer = new Authorizer($scope.membership)
    $scope.csrf_token = angular.element('meta[name="csrf-token"]').attr('content')
    $scope.posts = []
    $scope.current_page = 1
    $scope.total_posts_count = 1
    $scope.posts_per_page = 20
    $scope.max_size = 5 # number of pagination buttons
    $scope.UsersHelper = UsersHelper
    $scope.sort_params = "order_by_votes"
    $scope.collection_id = null

    $scope.get_posts = () ->
      Post.all(page: $scope.current_page, sort: $scope.sort_params, collection_id: $scope.collection_id).$promise.then (response) ->
        $scope.posts = response.posts
        $scope.total_posts_count = response.total_posts_count

    $scope.$watch 'current_page + sort_params + collection_id', ->
      $scope.get_posts()

    $scope.$on 'onRepeatLast', (scope, element, attrs) ->
      return if attrs.onLastRepeat != "posts"
      $timeout ->
        iconify_links()
        window.init_share_link_events()
        gsdk.initPopovers()
      , 1

    $scope.upvote_post = (post) ->
      Post.upvote({id: post.id}, post).$promise.then (p) ->
        angular.copy(p, post)

    $scope.unvote_post = (post) ->
      Post.unvote({id: post.id}, post).$promise.then (p) ->
        angular.copy(p, post)

    $scope.sort_class = (sort) ->
      return "active" if sort == $scope.sort_params && !$scope.collection_id

    $scope.collection_class = (collection_id) ->
      return "active" if collection_id == $scope.collection_id

    $scope.update_sort_params = (sort) ->
      $scope.sort_params = sort
      $scope.collection_id = null

    $scope.update_collection_id = (id) ->
      $scope.sort_params = "order_by_votes"
      $scope.collection_id = id

]

