class window.GroupSearch

  constructor: (@$container) ->
    return unless @$container.length

    @client = new AlgoliaSearch(gon.application_id, gon.api_key_search, { hosts: gon.hosts })
    @_initGroupSearch()

  _initGroupSearch: ->
    @$container.typeahead({
        hint: true
        highlight: true
      }
      source: @client.initIndex(gon.group_index).ttAdapter()
      displayKey: 'name'
      templates:
        empty: "<div class='tt-empty-message'>No group matching your query</div>"
        suggestion: (hit) ->
          return "<div class='tt-item-group'><a href='/groups/#{hit.subdomain}'>#{hit.name}</a></div>";
    ).on 'typeahead:selected', (event, selection) ->
      window.location.href = "/groups/" + selection.subdomain

