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
  'Group'
  'Post'
  ($scope, $routeParams, $resource, $timeout, $modal, $log, Auth, UsersHelper, Authorizer, POLICIES, Group, Post) ->
    init_authentication($scope, Auth)
    $scope.is_loading = false

    if is_on_group_domain()
      init_group_data($scope)
      init_group_helpers($scope, POLICIES, Authorizer, UsersHelper)
      init_group_dom($scope, $timeout)

      init_pagination($scope, 20)
      init_posts_loading($scope, Post)
      init_posts_sort_filter($scope, Post)
      init_posts_voting($scope, Post)

      $scope.feature_post = (post) ->
        Post.feature({id: post.id}, post).$promise.then (p) ->
          angular.copy(p, post)
          init_posts_loading($scope, Post)

    else
      init_group_helpers($scope, POLICIES, Authorizer, UsersHelper)
      init_pagination($scope, 10)
      init_groups_loading($scope, Group)

      $scope.$on 'onRepeatLast', (scope, element, attrs) ->
        $timeout ->
          gsdk.initPopovers()
]

# Group data
init_group_data = ($scope) ->
  $scope.group = gon.group
  $scope.membership = gon.membership
  $scope.current_group_collections = gon.current_group_collections
  $scope.collections_to_show = gon.collections_to_show
  $scope.hidden_collections = gon.hidden_collections
  $scope.collection_icon_classes = gon.collection_icon_classes
  $scope.sample_icon_class = $scope.collection_icon_classes[Math.floor(Math.random()*$scope.collection_icon_classes.length)]

# Group helpers
init_group_helpers = ($scope, POLICIES, Authorizer, UsersHelper) ->
  $scope.isBlank = isBlank
  $scope.POLICIES = POLICIES
  if is_on_group_domain()
    $scope.authorizer = new Authorizer($scope.membership)
  $scope.csrf_token = angular.element('meta[name="csrf-token"]').attr('content')
  $scope.UsersHelper = UsersHelper

# Dom initialization
init_group_dom = ($scope, $timeout) ->
  $scope.init_checkboxes = () ->
    $timeout ->
      $('[data-toggle="checkbox"]').each () ->
        $(@).checkbox()

  $timeout ->
    new PostSearch($("input#post_search"))

  $scope.$on 'onRepeatLast', (scope, element, attrs) ->
    return if attrs.onLastRepeat != "posts"

    $timeout ->
      iconify_links()
      window.init_share_link_events()
      gsdk.initPopovers()

# Pagination
init_pagination = ($scope, per_page) ->
  $scope.current_page = 1
  $scope.model = current_page: 1
  $scope.total_count = 1
  $scope.per_page = per_page
  $scope.max_size = 5 # number of pagination buttons

  $scope.setPage = (pageNo) ->
    $scope.model.current_page = pageNo

  $scope.page_changed = () ->
    $scope.current_page = $scope.model.current_page

# Post loading
init_posts_loading = ($scope, Post) ->
  $scope.get_posts = () ->
    showLoader("Loading posts...")
    $scope.is_loading = true
    Post.all(page: $scope.current_page, sort: $scope.sort_params, collection_id: $scope.collection_id).$promise.then (response) ->
      $scope.posts_queried = true
      $scope.posts = response.posts
      $scope.total_count = response.total_count
      hideLoader()
      window.scrollTo(0, 0)
      $scope.is_loading = false

  $scope.$watch 'current_page + sort_params + collection_id', ->
    $scope.get_posts()

# Post sort & filter
init_posts_sort_filter = ($scope, Post) ->
  $scope.sort_params = "order_by_votes"
  $scope.collection_id = null
  $scope.current_collection = null
  $scope.posts = []
  $scope.posts_queried = false

  $scope.sort_class = (sort) ->
    return "active" if sort == $scope.sort_params && !$scope.collection_id

  $scope.collection_class = (collection_id) ->
    return "active" if collection_id == $scope.collection_id

  $scope.update_sort_params = (sort) ->
    $scope.sort_params = sort
    $scope.collection_id = null
    $scope.current_collection = null

  $scope.update_collection_id = (id) ->
    $scope.sort_params = "order_by_votes"
    $scope.collection_id = id
    $scope.current_collection = _.find $scope.collections_to_show, (collection) ->
      collection.id == $scope.collection_id

# Post voting
init_posts_voting = ($scope, Post) ->
  $scope.upvote_post = (post) ->
    Post.upvote({id: post.id}, post).$promise.then (p) ->
      angular.copy(p, post)

  $scope.unvote_post = (post) ->
    Post.unvote({id: post.id}, post).$promise.then (p) ->
      angular.copy(p, post)

# Groups loading
init_groups_loading = ($scope, Group) ->
  $scope.get_groups = () ->
    showLoader("Loading groups...")
    $scope.is_loading = true
    Group.all(page: $scope.current_page).$promise.then (response) ->
      $scope.groups = response.groups
      $scope.total_count = response.total_count
      hideLoader()
      window.scrollTo(0, angular.element(".explore-title").offset().top)
      $scope.is_loading = false

  $scope.$watch 'current_page', ->
    $scope.get_groups()
