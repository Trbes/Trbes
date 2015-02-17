class window.CreateGroup

  constructor: (@$container) ->
    return unless @$container.length

    @_init_form_validation()

  # Sign-up form validation
  _init_form_validation: ->
    @$container.validate
      rules:
        name:
          required: true
          minlength: 2
        short_name:
          required: true
          subdomain: true
          minlength: 2
          maxlength: 20

      highlight: (element) ->
        $(element).
          closest(".form-group").removeClass("has-feedback has-success").addClass("has-feedback has-error").
          find(".form-control-feedback").removeClass("fa-check-circle").addClass("fa-times-circle")

      success: (element) ->
        $(element).
          closest(".form-group").removeClass("has-feedback has-error").addClass("has-feedback has-success").
          find(".form-control-feedback").removeClass("fa-times-circle").addClass("fa-check-circle")
