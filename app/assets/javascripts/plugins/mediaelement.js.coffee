$(document).on 'ready page:load page:restore', ->
  $('video.mediaelement').mediaelementplayer
    startVolume: 0.1
    features: ['playpause', 'progress', 'current', 'duration', 'tracks', 'volume', 'fullscreen', 'logo']
    logo:
      text: gon.site_title,
      link: gon.root_url
