$(document).on 'ready page:load page:restore', ->

  pull = $('nav.l-nav-container #pull')
  menu = $('nav.l-nav-container ul')
  menuHeight = menu.height()
  w = $(window).width()

  $(pull).on 'click', (e) ->
    e.preventDefault()
    menu.slideToggle()
    return

  $(window).on 'resize', ->
    w = $(window).width()
    if w > 480 and menu.is ':hidden'
      menu.removeAttr 'style'
    return
  return
