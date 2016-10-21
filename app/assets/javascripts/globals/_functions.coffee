# is this a small screen?
@isSmall = ->
  if typeof Foundation != 'undefined'
    Foundation.MediaQuery.current == 'small'

# is this a medium screen?
@isMedium = ->
  if typeof Foundation != 'undefined'
    Foundation.MediaQuery.current == 'medium'

@isSmallBreakOne = ->
  matchMedia('(max-width: 949px)').matches

# Smooth scroll on anchor tags
@scroll_to_anchor = ->
  $('.anchor').on 'click', ->
    $(window).scrollTo $(this).attr('href'), 'slow', offset: { top: -10 }
    false
  return

# Throttle function
@throttle = (callback, delay) ->
  last = undefined
  timer = undefined
  ->
    context = this
    now = +new Date
    args = arguments
    if last and now < last + delay
      # le délai n'est pas écoulé on reset le timer
      clearTimeout timer
      timer = setTimeout((->
        last = now
        callback.apply context, args
        return
      ), delay)
    else
      last = now
      callback.apply context, args
    return

@sleep = (ms) ->
  start = new Date().getTime()
  continue while new Date().getTime() - start < ms

# Display date as "xx minutes ago"
@friendly_date = ->
  if gon.date_format == 'ago' && $('.date-format').length > 0
    moment.locale(gon.language)
    $('.date-format').each (_index, _value) ->
      that = $(@)
      unless that.hasClass('is-ago')
        created_at = that.attr('datetime')
        that.text(moment(created_at).fromNow())
        that.addClass('is-ago')

#
# Forms
# =====
@reset_form = (inputs) ->
  for input in inputs
    $(input).val ''

#
# Masonry
# =======
# Reload Masonry position for new added items
@reload_masonry = (init = false, callback = ->) ->
  $container = $('#masonry-container')
  if $container.length > 0 && !isSmall()
    $container.imagesLoaded ->
      if init
        $container.masonry
          itemSelector: '.masonry-item'
      else
        $container.masonry('reloadItems').masonry()
      callback()

#
# Foundation Fix
# ==============
# Sticky sidebar
@sticky_sidebar_fix = ->
  if $('[data-sticky]').length > 0
    $('[data-sticky]').foundation '_calc', true
