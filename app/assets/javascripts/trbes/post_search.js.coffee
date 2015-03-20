class window.PostSearch

  constructor: (@$container) ->
    return unless @$container.length

    @client = new AlgoliaSearch(gon.application_id, gon.group_scope_api_key_search, { hosts: gon.hosts })
    @client.setSecurityTags("(public,#{gon.group_tag})")

    @_initPostSearch()

  _initPostSearch: ->
    @$container.typeahead({ hint: false }
      source: @client.initIndex(gon.post_index).ttAdapter()
      templates:
        empty: "<div class='tt-empty-message'>No post matching your query</div>"
        suggestion: (hit) ->
          return "<div><a href='/groups/#{hit.slug}'>#{hit.title}</a></div>"
    )
