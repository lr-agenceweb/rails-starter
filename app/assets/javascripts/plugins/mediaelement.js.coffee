$(document).on 'ready page:load page:restore', ->
  $('video, audio').mediaelementplayer
    startVolume: 0.2