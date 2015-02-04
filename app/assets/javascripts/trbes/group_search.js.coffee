class window.GroupSearch

  constructor: (@$container) ->
    return unless @$container.length

    @client = new AlgoliaSearch(gon.application_id, gon.api_key_search)
    @_initGroupSearch()

  _initGroupSearch: ->
    @$container.typeahead({ hint: false }
      source: @client.initIndex('Group').ttAdapter()
      templates:
        suggestion: (hit) ->
          return "<li><a href='/groups/#{hit.subdomain}'>#{hit.name}</a></li>";
    )
