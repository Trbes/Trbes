class window.SendInvite

  constructor: (@$container) ->
    return unless @$container.length

    @_init_events()

  _init_events: ->
    refresh_button = @_refresh_button
    container = @$container
    @$container.on "click", ".btn-send-invite", (e) ->
      e.preventDefault()
      $button = $(this)

      if $("#fiv_emails").val() == ""
        $(".fiv-emails .col-sm-10").tooltip(
          placement: "top"
          title: "Please enter some email addresses"
        ).tooltip("show")

        refresh_button($button)
        return false
      else
        $(".fiv-emails .col-sm-10").tooltip("destroy")

      container.ajaxSubmit
        success: ->
          # Set button success state
          $button.morphingButton
            action: 'setState'
            icon: 'fa-check'
            state: 'success'

          # Refresh email addresses input
          $("#fiv_emails").importTags('')

          # Show modal
          $("#modal_invitation_success").modal(
            backdrop: "static"
            show: true
          ).on "hide.bs.modal", (e) ->
            refresh_button($button)


  # Sign-up form validation
  _refresh_button: (button) ->
    parent = button.parent()
    $("#btn_send_invite_template").clone().appendTo(parent.closest(".col-sm-4")).removeAttr("id style").morphingButton()
    button.parent().remove()
