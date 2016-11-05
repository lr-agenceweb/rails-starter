$(document).on 'ready page:load page:restore', ->
  $nav = $('.menu__nav')
  $menu = $nav.find('.menu__nav__ul')
  $pull = $nav.find('#pull')

  $pull.on 'click', (e) ->
    e.preventDefault()
    $menu.slideToggle()
    return

  $(window).on 'resize', ->
    w = $(window).width()
    if w > 480 and $menu.is ':hidden'
      $menu.removeAttr 'style'
    return
  return
