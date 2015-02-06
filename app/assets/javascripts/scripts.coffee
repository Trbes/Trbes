# Write miscelaneous javascript code here
$.validator.addMethod "subdomain", (value, element) ->
  return this.optional(element) || /^[a-zA-Z0-9][a-zA-Z0-9.-]+[a-zA-Z0-9]$/.test value
, "* Invalid subdomain"


# Document ready
$ ->
  # Show favicon before external urls
  iconify_links(16)

  # Trigger main slide menu
  $(".js-menu-trigger,.js-menu-screen").on "click touchstart", (e) ->
    $(".js-menu,.js-menu-screen").toggleClass "is-visible"
    e.preventDefault()


  # Check and point our boy to the focused form field
  check_and_point_to_class = (elem) ->
    $("#su_cody").removeClass()
    if $(".form-group.has-error").length > 0
      $("#su_cody").addClass("has-error")
      return

    point_to_class = $(elem).data("point-to-class")
    if point_to_class
      $("#su_cody").addClass(point_to_class)

  if $(".su-form").length > 0
    $(".su-form input[type='email'],
       .su-form input[type='text'],
       .su-form input[type='password']").on "focus", (e) ->

      check_and_point_to_class(e.target)

    # $(".su-form input").on "blur", (e) ->
    #   $("#su_cody").removeClass()


  # Sign-up form validation
  $("form.su-form").validate
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


  # Toggle password
  $(".fg-su-show-password input[type='checkbox']").change (e) ->
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


  # Create group form validation
  $("form.cg-form").validate
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

  # Toggle add post form
  $("#btn_add_post").click (e) ->
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

  new GroupSearch($("input#group_search"))
  new PostSearch($("input#post_search"))
