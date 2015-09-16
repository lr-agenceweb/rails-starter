position_footer = ->
  mFoo = $('#footer')
  if $(document.body).height() + mFoo.outerHeight() < $(window).height() and mFoo.css('position') == 'fixed' or $(document.body).height() < $(window).height() and mFoo.css('position') != 'fixed'
    mFoo.css
      position: 'fixed'
      bottom: '0'
  else
    mFoo.css position: 'relative'
  return

$(document).on 'ready page:load page:restore', ->
  $(window).scroll position_footer
  $(window).resize position_footer

  sleep 30
  $(window).resize()
  return
