window.csPageOptions =
  textarea_id: 'contact_list'
  skipSourceMenu: true
  afterInit: ->
    i = undefined
    links = document.getElementsByClassName('delayed')
    i = 0
    while i < links.length
      # make the links that launch a popup clickable by setting the href property
      links[i].href = '#'
      i++
  afterSubmitContacts: (contacts, source, owner) ->
    for contact in contacts
      $("#fiv_emails").addTag(contact.email[0].address)

# Asynchronously include the widget library.
((u) ->
  d = document
  s = 'script'
  a = d.createElement(s)
  m = d.getElementsByTagName(s)[0]
  a.async = 1
  a.src = u
  m.parentNode.insertBefore a, m
  return
) '//api.cloudsponge.com/widget/363b2edeea51de27669ccd7104aa79f5796cb0a4.js'
