$(document).on 'ready page:load page:restore', ->

  if $('.mediaelement').length > 0
    turn_off_the_light = gon.turn_off_the_light

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
        success: (mediaelement, domObject) ->
          mediaelement.addEventListener 'ended', (e) ->
            remove_darkness() if turn_off_the_light

          mediaelement.addEventListener 'pause', (e) ->
            remove_darkness() if turn_off_the_light

          mediaelement.addEventListener 'play', (e) ->
            create_darkness() if turn_off_the_light && !$('#shadow').hasClass('night')

create_darkness = (sel=$('#shadow'), klass='night') ->
  sel.css('height', $(document).outerHeight()).hide()
  value = $('.mediaelement .mejs-playpause-button button').attr('aria-label')
  sel.addClass(klass).fadeIn(200)
  return

remove_darkness = (sel=$('#shadow'), klass='night') ->
  sel.fadeOut 200, ->
    $(@).removeClass(klass)
    $(@).css 'height', 0
    return