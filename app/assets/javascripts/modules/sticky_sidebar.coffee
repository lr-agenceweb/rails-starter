$(document).on 'ready page:load page:restore', ->
  if $('#blog_sidebar').length > 0
    sticky_sidebar()

    $(window).on 'resize', throttle(((e) ->
      sticky_sidebar()
    ), 200)

sticky_sidebar = ->
  $blogs = $('#blogs-container')
  $sidebar = $('#blog_sidebar').parent()
  $parent = $sidebar.parent()

  if Foundation.MediaQuery.atLeast('large')
    $sidebar.css('position', 'absolute')
    $parent.css('position', 'relative')
    dTop = $sidebar.offset().top
    speed = 0
    margin = 20

    # Auto stick sidebar when page is loaded at first time
    do_magick($sidebar, $parent, $blogs, dTop, speed, margin)

    $(window).on 'scroll', throttle(((e) ->
      do_magick($sidebar, $parent, $blogs, dTop, speed, margin)
    ), 0)
  else
    $sidebar.css('position', 'static')
    $parent.css('position', 'static')
    $(window).unbind('scroll')

do_magick = ($sidebar, $parent, $blogs, dTop, speed, margin) ->
  sTop = $(window).scrollTop()
  if sTop + margin > dTop
    if (sTop + margin) < ($blogs.offset().top + $blogs.height() - $sidebar.height())
      $sidebar.css('bottom', '')
      $sidebar.stop().animate({ top: sTop - $parent.offset().top + margin }, speed)
    else
      $sidebar.css('top', '')
      $sidebar.stop().animate({ bottom: dTop - $parent.offset().top }, speed)
  else
    $sidebar.stop().animate({ top: dTop - $parent.offset().top }, speed)
