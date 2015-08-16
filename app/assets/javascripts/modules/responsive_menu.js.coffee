$(document).on 'ready page:load page:restore', ->

  pull = $('nav.l-nav-container #pull')
  menu = $('nav.l-nav-container ul')
  menuHeight = menu.height()
  w = $(window).width()

  no_js_friendly(w, pull, menu)

  $(pull).on 'click', (e) ->
    e.preventDefault()
    menu.slideToggle()
    return

  $(window).on 'resize', ->
    w = $(window).width()
    no_js_friendly(w, pull, menu)
    if w > 480 and menu.is ':hidden'
      menu.removeAttr 'style'
    return
  return

no_js_friendly = (w, pull, menu) ->
  if w < 480
    if menu.is ':visible'
      menu.slideUp()
      pull.css 'display', 'block'
  else
    menu.css 'display', 'block'
    pull.css 'display', 'none'
