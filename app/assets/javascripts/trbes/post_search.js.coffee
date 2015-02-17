class window.PostSearch

  constructor: (@$container) ->
    return unless @$container.length

    @client = new AlgoliaSearch(gon.application_id, gon.group_scope_api_key_search, { hosts: gon.hosts })
    @client.setSecurityTags("(public,#{gon.group_tag})")

    @_initPostSearch()

  _initPostSearch: ->
    @$container.typeahead({ hint: false }
      source: @client.initIndex('Post').ttAdapter()
      templates:
        suggestion: (hit) ->
          return "<li><a href='/posts/#{hit.slug}'>#{hit.title}</a></li>";
    )
