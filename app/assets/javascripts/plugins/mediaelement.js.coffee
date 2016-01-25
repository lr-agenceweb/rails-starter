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


    if turn_off_the_light
      sel = $('#shadow')
      $('.mediaelement .mejs-playpause-button button, .mediaelement .mejs-overlay-button, .mediaelement').on 'click', (e) ->
        klass = 'night'
        sel.css('height', $(document).outerHeight()).hide()
        value = $('.mediaelement .mejs-playpause-button button').attr('aria-label')
        if value == 'Play'
          sel.addClass klass
          $('.mejs-container').css('z-index', '3')
        else
          remove_darkness()
        sel.toggle()


remove_darkness = (sel=$('#shadow'), klass='night') ->
  sel.removeClass klass
  sel.css('height', 0).hide()