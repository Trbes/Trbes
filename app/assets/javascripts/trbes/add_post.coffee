class window.AddPost

  constructor: (@$container) ->
    return unless @$container.length

    @_init_events()
    @_init_form_validations()

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

  # Sign-up form validation
  _init_form_validations: ->
    $("#add_a_post form").each ()->
      $(this).validate
        rules:
          "post[title]":
            required: true
            minlength: 10
            maxlength: 100
          "post[body]":
            required: true
          "post[link]":
            required: true
            url: true
          "post[attachments_attributes][0][image]":
            required: true

        highlight: (element) ->
          $(element).
            closest(".form-group").removeClass("has-feedback has-success").addClass("has-feedback has-error").
            find(".form-control-feedback").removeClass("fa-check-circle").addClass("fa-times-circle")

        success: (element) ->
          $(element).
            closest(".form-group").removeClass("has-feedback has-error").addClass("has-feedback has-success").
            find(".form-control-feedback").removeClass("fa-times-circle").addClass("fa-check-circle")
