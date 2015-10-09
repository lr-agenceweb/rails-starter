change = ->
  for player in document.getElementsByClassName 'video-js'
    video = videojs(player)

before_change = ->
  for player in document.getElementsByClassName 'video-js'
    video = videojs(player)
    video.dispose()

$(document).on('page:before-unload', before_change)
$(document).on('page:change', change)