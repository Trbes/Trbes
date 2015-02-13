class window.AddPost

  constructor: (@$container) ->
    return unless @$container.length

    @_init_events()

  # Sign-up form validation
  _init_events: ->
    @$container.click (e) ->
      $("#add_a_post").toggleClass("open")

    $(".cancel-post").click (e) ->
      $("#add_a_post").removeClass("open")

    $(".fnp-togglers a").click (e) ->
      e.preventDefault()
      return if $(this).hasClass("active")

      $(this).addClass("active").
        siblings().removeClass("active")
      $("#add_a_post " + $(this).attr("href")).addClass("active").
        siblings().removeClass("active")
