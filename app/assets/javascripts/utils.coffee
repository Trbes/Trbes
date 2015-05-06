root = exports ? this

root.isBlank = (str) ->
  return (!str || str.trim().length == 0 || /^\s*$/.test(str));

root.showLoader = (msg, selector) ->
  options =
    text: msg
    class: "fa fa-refresh fa-spin"
    position: "overlay"
    tpl: '<span class="isloading-wrapper %wrapper%">%text%<i class="%class%"></i></span>'

  if isBlank(selector)
    $.isLoading options
  else
    $(selector).isLoading options

root.hideLoader = (selector) ->
  if isBlank(selector)
    $.isLoading "hide"
  else
    $(selector).isLoading "hide"
