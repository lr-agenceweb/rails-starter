# is this a small screen?
@isSmall = ->
  if typeof Foundation != 'undefined'
    matchMedia(Foundation.media_queries.small).matches and !matchMedia(Foundation.media_queries.medium).matches

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
