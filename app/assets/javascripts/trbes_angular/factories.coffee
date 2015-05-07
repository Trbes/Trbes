@trbes.factory('Post', [
  '$resource'
  ($resource) ->
    $resource '/v1/posts/:id.json', null,
      all:
        url: '/v1/posts.json'
        method: 'GET'
      upvote:
        url: '/v1/posts/:id/upvote.json'
        method: 'PUT'
      unvote:
        url: '/v1/posts/:id/unvote.json'
        method: 'PUT'
      feature:
        url: '/v1/posts/:id/feature.json'
        method: 'PUT'
])

@trbes.factory('Group', [
  '$resource'
  ($resource) ->
    $resource '/v1/groups/:id.json', null,
      all:
        url: '/v1/groups.json'
        method: 'GET'
])

app.factory('subdomain', [
  '$location'
  ($location) ->
    host = $location.host()
    if host.indexOf('.') < 0
      null
    else
      host.split('.')[0]
])
