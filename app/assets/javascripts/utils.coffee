root = exports ? this

root.isBlank = (str) ->
  return (!str || str.trim().length == 0 || /^\s*$/.test(str));
