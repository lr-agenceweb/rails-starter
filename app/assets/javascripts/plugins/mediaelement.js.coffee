$(document).on 'ready page:load page:restore', ->
  $('video.mediaelement').each (index, element) ->  #mediaelementplayer
    element = $(element)
    $(element).attr('autoplay', 'true') if element.data('autoplay') is true

    element.mediaelementplayer
      startVolume: if element.data('mute') is true then 0.0 else 0.3
      loop: element.data('loop')
      alwaysShowControls: element.data('controls')
      features: ['playpause', 'progress', 'current', 'duration', 'tracks', 'volume', 'fullscreen', 'logo']
      logo:
        text: gon.site_title,
        link: gon.root_url
