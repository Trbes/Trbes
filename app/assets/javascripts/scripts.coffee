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
      $("#su_boy").removeClass()
      if point_to_class
        $("#su_boy").addClass(point_to_class)

    $(".su-form input").on "focus", (e) ->
      point_to_class = $(e.target).data("point-to-class")
      $("#su_boy").removeClass()
      if point_to_class
        $("#su_boy").addClass(point_to_class)

    $(".su-form input").on "blur", (e) ->
      $("#su_boy").removeClass()

