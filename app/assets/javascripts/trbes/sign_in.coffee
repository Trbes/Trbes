class window.SignIn

  constructor: (@$container) ->
    return unless @$container.length

    @_init_form_validation()

  # Sign-up form validation
  _init_form_validation: ->
    @$container.validate
      rules:
        "user[email]":
          required: true
          email: true
        "user[password]":
          minlength: 8
          required: true

      highlight: (element) ->
        $(element).
          closest(".form-group").removeClass("has-feedback has-success").addClass("has-feedback has-error").
          find(".form-control-feedback").removeClass("fa-check-circle").addClass("fa-times-circle")
        $("#si_cody").addClass("has-error")

      success: (element) ->
        $(element).
          closest(".form-group").removeClass("has-feedback has-error").addClass("has-feedback has-success").
          find(".form-control-feedback").removeClass("fa-times-circle").addClass("fa-check-circle")

        if $(".form-group.has-error").length == 0
          $("#si_cody").removeClass("has-error")

      onkeyup: (element) ->
        return unless $(element).attr("id") == "si_email"

        if $(element).val() == "hello@trbes.com"
          $(element).
            closest(".form-group").removeClass("has-feedback has-error").addClass("has-feedback has-success").
            find(".form-control-feedback").removeClass("fa-times-circle").addClass("fa-check-circle")
          $(".fg-si-password").hide()
          $(".si-already-signed-up").show()
        else
          $(element).
            closest(".form-group").removeClass("has-feedback has-error has-success")
          $(".fg-si-password").show()
          $(".si-already-signed-up").hide()
