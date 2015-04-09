class window.PostSearch

  constructor: (@$container) ->
    return unless @$container.length

    @client = new AlgoliaSearch(gon.application_id, gon.group_scope_api_key_search, { hosts: gon.hosts })
    @client.setSecurityTags("(public,#{gon.group_tag})")

    @_initPostSearch()

  _initPostSearch: ->
    @$container.typeahead({
        hint: true
        highlight: true
      }
      displayKey: 'title'
      source: @client.initIndex(gon.post_index).ttAdapter({
        facets: '*'
        facetFilters: ['state:published']
      })
      templates:
        empty: "<div class='tt-empty-message'>No post matching your query</div>"
        suggestion: (hit) ->
          return "<div><a href='/posts/#{hit.slug}'>#{hit.title}</a></div>"
    ).on 'typeahead:selected', (event, selection) ->
      window.location.href = "/posts/" + selection.slug
