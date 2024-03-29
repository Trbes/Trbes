class window.AddPost

  constructor: (@$container) ->
    return unless @$container.length

    @_init_events()
    @_init_form_validations()

  _init_events: ->
    $(".form-new-post").submit ->
      if $(this).valid() == true
        $(".btn-submit-post").prop("disabled", true)

    $(".toggle-post-type").click (e) ->
      e.preventDefault()
      that = $(this)
      return if that.hasClass("active")

      that.addClass("active").
        closest("li").siblings().find("a").removeClass("active")

      $(that.attr("href"), @$container).addClass("active").
        siblings().removeClass("active")

      $(".new-" + that.data("post-type") + "-post", @$container).removeClass("hidden").
        siblings().addClass("hidden")

      that.closest(".dropdown").find("#select_post_type .post-type-text").text(that.data("post-type"))

  # Sign-up form validation
  _init_form_validations: ->
    $("form", @$container).each ()->
      that = $(this)
      $(this).validate
        rules:
          "post[title]":
            required: true
            minlength: 5
            maxlength: 100
          "post[body]":
            required: that.attr("id") == "form_new_text_post"
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
