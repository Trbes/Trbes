# Write miscelaneous javascript code here
$.validator.addMethod "subdomain", (value, element) ->
  return this.optional(element) || /^[a-zA-Z0-9][a-zA-Z0-9.-]+[a-zA-Z0-9]$/.test value
, "* Invalid subdomain"


# Document ready
$ ->
  $('[data-toggle="tooltip"]').tooltip()

  # Show favicon before external urls
  iconify_links(16)

  # Trigger main slide menu
  $(".js-menu-trigger,.js-menu-screen").on "click touchstart", (e) ->
    $(".js-menu,.js-menu-screen").toggleClass "is-visible"
    e.preventDefault()

  new SignUp($("form.su-form"))
  new SignIn($("form.si-form"))
  new CreateGroup($("form.cg-form"))
  new AddPost($("#btn_add_post"))
  new GroupSearch($("input#group_search"))
  new PostSearch($("input#post_search"))

  $('.cloudinary-fileupload').bind 'cloudinarydone', (e, data) ->
    $('#preview').html $.cloudinary.image(data.result.public_id,
      format: data.result.format
      version: data.result.version
      crop: 'fill'
      width: 150
      height: 100)
    $('.image_public_id').val data.result.public_id
    true

  $(".best_in_place").best_in_place()

  $(".upload").on "click", (e) ->
    e.preventDefault()
    $(".file-uploader").toggleClass("hidden")

  $("a.vote").on "click", (e) ->
    e.preventDefault()
    target = $(this)
    $.ajax
      method: "PUT"
      url: target.attr("href")
      success: (result) ->
        target.
          siblings(".vote-count").html(result.new_total_votes).addClass("voted").
          closest(".post-upvote").closest(".post").find(".post-content").addClass("voted")

