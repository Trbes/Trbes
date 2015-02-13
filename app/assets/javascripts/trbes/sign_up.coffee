class window.SignUp

  constructor: (@$container) ->
    return unless @$container.length

    @_init_form_validation()
    check_and_point_to_class = @_check_and_point_to_class
    @$container.find("input[type='email'],
                      input[type='text'],
                      input[type='password']").on "focus", (e) ->
      check_and_point_to_class(e.target)

    # Toggle password
    $(".fg-su-show-password input[type='checkbox']").change (e) ->
      if $(this).is(":checked")
        $("#su_password").prop("type", "text")
      else
        $("#su_password").prop("type", "password")

  # Sign-up form validation
  _init_form_validation: ->
    check_and_point_to_class = @_check_and_point_to_class
    @$container.validate
      rules:
        email:
          required: true
          email: true
        name:
          minlength: 5
          required: true
        # title:
        #   minlength: 2
        password:
          minlength: 8
          required: true

      highlight: (element) ->
        $(element).
          closest(".form-group").removeClass("has-feedback has-success").addClass("has-feedback has-error").
          find(".form-control-feedback").removeClass("fa-check-circle").addClass("fa-times-circle")

        $("#su_cody").addClass("has-error")

      success: (element) ->
        $(element).
          closest(".form-group").removeClass("has-feedback has-error").addClass("has-feedback has-success").
          find(".form-control-feedback").removeClass("fa-times-circle").addClass("fa-check-circle")

        $("#su_cody").removeClass("has-error")
        check_and_point_to_class(element.closest(".form-group").find("input")[0])

  # Check and point our boy to the focused form field
  _check_and_point_to_class: (elem) ->
    $("#su_cody").removeClass()
    if $(".form-group.has-error").length > 0
      $("#su_cody").addClass("has-error")
      return

    point_to_class = $(elem).data("point-to-class")
    if point_to_class
      $("#su_cody").addClass(point_to_class)
