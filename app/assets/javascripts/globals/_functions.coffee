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