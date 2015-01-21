# Write miscelaneous javascript code here

# Trigger main slide menu
$(".js-menu-trigger,.js-menu-screen").on "click touchstart", (e) ->
  $(".js-menu,.js-menu-screen").toggleClass "is-visible"
  e.preventDefault()