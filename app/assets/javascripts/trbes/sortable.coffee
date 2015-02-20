class window.Sortable
  constructor: (@$container) ->
    return unless @$container.length
    @_initSortable()

  _initSortable: ->
    @$container.sortable
      axis: 'y'
      items: @$container.data("items")
      cursor: 'move'

      sort: (e, ui) ->
        ui.item.addClass('active-item-shadow')
      stop: (e, ui) ->
        ui.item.removeClass('active-item-shadow')
        ui.item.effect('highlight', {}, 1000)
      update: (e, ui) ->
        resource_name = ui.item.data('resource')
        data = {}

        data[resource_name] = row_order_position: ui.item.index()
        $.ajax
          type: 'PUT'
          url: "#{ui.item.data('path')}/#{ui.item.data('id')}"
          dataType: 'json'
          data: data
