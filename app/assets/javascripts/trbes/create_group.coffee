class window.CreateGroup

  constructor: (@$container) ->
    return unless @$container.length

    @_init_form_validation()

  # Sign-up form validation
  _init_form_validation: ->
    @$container.validate
      rules:
        "group[name]":
          required: true
          minlength: 2
          remote:
            url: "/validate/group_name"
            type: "post"
        "group[subdomain]":
          required: true
          minlength: 2
          maxlength: 20
          remote:
            url: "/validate/group_subdomain"
            type: "post"
        "group[tagline]":
          required: true
          remote:
            url: "/validate/group_tagline"
            type: "post"

      highlight: (element) ->
        $(element).
          closest(".form-group").removeClass("has-feedback has-success").addClass("has-feedback has-error").
          find(".form-control-feedback").removeClass("fa-check-circle").addClass("fa-times-circle")

      success: (element) ->
        $(element).
          closest(".form-group").removeClass("has-feedback has-error").addClass("has-feedback has-success").
          find(".form-control-feedback").removeClass("fa-times-circle").addClass("fa-check-circle")
