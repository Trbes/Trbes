# Write miscelaneous javascript code here

# Trigger main slide menu
$(".js-menu-trigger,.js-menu-screen").on "click touchstart", (e) ->
  $(".js-menu,.js-menu-screen").toggleClass "is-visible"
  e.preventDefault()

# Document ready
$ ->

  # Check and point our boy to the focused form field
  if $(".su-form").length > 0
    check_and_point_to_input = () ->
      point_to_class = $(".su-form input:focus").eq(0).data("point-to-class")
      $("#su_cody").removeClass()
      if point_to_class
        $("#su_cody").addClass(point_to_class)

    $(".su-form input[type='email'],
       .su-form input[type='text'],
       .su-form input[type='password']").on "focus", (e) ->
      point_to_class = $(e.target).data("point-to-class")
      $("#su_cody").removeClass()
      if point_to_class
        $("#su_cody").addClass(point_to_class)

    # $(".su-form input").on "blur", (e) ->
    #   $("#su_cody").removeClass()

  # Sign-up form validation
  $("form.su-form").validate
    rules:
      email:
        required: true
        email: true
      name:
        minlength: 2
        required: true
      title:
        minlength: 2
      password:
        minlength: 8
        required: true

    highlight: (element) ->
      $(element).
        closest(".form-group").removeClass("has-feedback has-success").addClass("has-feedback has-error").
        find(".form-control-feedback").removeClass("fa-check-circle").addClass("fa-times-circle")

    success: (element) ->
      $(element).
        closest(".form-group").removeClass("has-feedback has-error").addClass("has-feedback has-success").
        find(".form-control-feedback").removeClass("fa-times-circle").addClass("fa-check-circle")

  # Toggle password
  $(".fg-su-show-password input[type='checkbox']").click (e) ->
    if $(this).is(":checked")
      $("#su_password").prop("type", "text")
    else
      $("#su_password").prop("type", "password")

  # Sign-in form validation
  $("form.si-form").validate
    rules:
      email:
        required: true
        email: true
      password:
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

