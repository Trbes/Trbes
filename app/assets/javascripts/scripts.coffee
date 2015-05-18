# Write miscelaneous javascript code here
$.validator.addMethod "subdomain", (value, element) ->
  return this.optional(element) || /^[a-zA-Z0-9][a-zA-Z0-9.-]+[a-zA-Z0-9]$/.test value
, "* Invalid subdomain"


# Document ready
$ ->
  new WOW().init()

  $('[data-toggle="tooltip"]').tooltip()

  # Bind select2 to best_in_place select for consistent behaviour across browsers
  $('body').on 'best_in_place:activate', '.best_in_place', ->
    @update = ->
    $(@).find('select').unbind('blur').select2(minimumResultsForSearch: -1, noFocus: true).select2("open")

  # Show favicon before external urls
  iconify_links()

  # Trigger main slide menu
  $(".js-menu-trigger,.js-menu-screen").on "click touchstart", (e) ->
    $(".js-menu,.js-menu-screen").toggleClass "is-visible"
    e.preventDefault()

  # Auto resize textareas when content grows out of their dimension
  $("textarea").on "focus", (e) ->
    $(@).autosize()

  new SignUp($("form.su-form"))
  new SignIn($("form.si-form"))
  new CreateGroup($("form.cg-form"))
  new AddPost($("#add_a_post"))
  new GroupSearch($("input#group_search"))
  new PostSearch($("input#post_search"))
  new SendInvite($(".form-invite"))
  new Sortable($(".collections-list"))
  new Sortable($(".collection-posts-list"))

  $('.cloudinary-fileupload').bind 'fileuploadstart', (e) ->
    $(this).closest("form").find("input[type='submit']").prop("disabled", true)
  .bind 'fileuploadfail', (e) ->
    $(this).closest("form").find("input[type='submit']").prop("disabled", false)
    humane.log("File upload failed, please try again", { addnCls: "humane-libnotify-error" })
  .bind 'cloudinarydone', (e, data) ->
    $(this).closest("form").find("input[type='submit']").prop("disabled", false)

    $('#preview').html $.cloudinary.image(data.result.public_id,
      format: data.result.format
      version: data.result.version
      crop: 'fill'
      width: 138
      height: 115)
    $('.image_public_id').val data.result.public_id
    true


  $(".best_in_place").best_in_place()
  $(".best_in_place.update-class-on-success").bind 'ajax:success', ->
    target = $(this)
    for klass in target.attr("class").split(" ")
      if klass.indexOf("updateable-") > -1
        target.removeClass(klass)
    target.addClass("updateable-" + target.data("bip-value"))


  $(".upload").on "click", (e) ->
    e.preventDefault()
    $($(this).data("target")).toggleClass("hidden").prop("disabled", (i, v) -> return !v )

  $(".comment-upvote a.vote:not(.not-logged-in)").on "click", (e) ->
    e.preventDefault()

    target = $(this)
    return false if target.attr("href") == "#"

    $.ajax
      method: "PUT"
      url: target.attr("href")
      success: (result) ->
        target.attr("href", result.new_vote_path).
          siblings(".vote-count").html(result.new_total_votes).addClass("voted").
          closest(".post-upvote").closest(".post").find(".post-content").addClass("voted")

        if result.voted_up
          target.addClass("done").attr("title", "Undo like").
            html("<i class='fa fa-check'></i><i class='fa fa-close'></i>")
        else
          target.removeClass("done").attr("title", "Like this").
            html("<i class='fa fa-thumbs-up'></i>").
            closest(".post").find(".post-content").removeClass("voted")

  $("#moderator_id").on "change", (e) ->
    $("form#add_moderator").attr("action", "/admin/memberships/#{this.value}")

  $(".select-icon-class").on "click", (e) ->
    $(this).addClass("active").siblings().removeClass("active").
      closest("form").find("#collection_icon_class").val($(this).data("icon-class"))

  ZeroClipboard.config
    swfPath: gon.zero_clipboard_path
  zeroclip = new ZeroClipboard(document.getElementById('copy_invite_link'))
  zeroclip.on 'ready', (readyEvent) ->
    zeroclip.on 'aftercopy', (event) ->
      humane.log("Copied invite link to clipboard", { addnCls: "humane-libnotify-success" })

  window.init_share_link_events = () ->
    $(".share-on-facebook").click (e) ->
      e.preventDefault()
      that = $(this)
      FB.ui {
        method: "feed"
        link: that.data("link")
        picture: that.data("image")
        name: that.data("title")
        description: that.data("body")
      }, (response) ->
        if response and !response.error_code
          console.log 'Success sharing to Facebook.'
        else
          console.log 'Error sharing to Facebook.'

    $(".share-on-twitter").click (e) ->
      e.preventDefault()
      width = 575
      height = 400
      left = ($(window).width() - width) / 2
      top = ($(window).height() - height) / 2
      url = @href
      opts = 'status=1' + ',width=' + width + ',height=' + height + ',top=' + top + ',left=' + left
      window.open url, 'twitter', opts

  window.init_share_link_events()

  $(document).on 'change', '.rails-submitable', ->
    $(@form).trigger 'submit.rails'
