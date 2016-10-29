#= require classes/picture_in_picture_class

$(document).on 'ready page:load page:restore', ->
  #
  # Audio
  # =====
  if $('audio.mediaelement').length > 0
    $('audio.mediaelement').each (index, element) ->
      # Variables
      $element = $(element)
      $element.attr('autoplay', 'true') if $element.data('autoplay') is true

      $element.mediaelementplayer
        alwaysShowControls: true,
        features: ['playpause','progress', 'current', 'duration', 'volume', 'logo'],
        audioVolume: 'horizontal'
        startVolume: 0.5
        logo:
          text: gon.site_title,
          link: gon.root_url
        success: (mediaelement, domObject, player) ->
          # Variables
          if gon.picture_in_picture
            pipc = new PictureInPicture(mediaelement, player, $('.post__audios'))
            pipc.set_offset()

            # Listener
            if isLargeUp()
              mediaelement.addEventListener 'playing', (e) ->
                picture_in_picture(pipc)

            mediaelement.addEventListener 'ended', (e) ->
              pipc.undo()

  #
  # Video
  # =====
  if $('video.mediaelement').length > 0
    turn_off_the_light = gon.turn_off_the_light
    $('body').append('<div id="shadow"></div>') if turn_off_the_light

    $('video.mediaelement').each (index, element) ->
      # Variables
      $element = $(element)
      $element.attr('autoplay', 'true') if $element.data('autoplay') is true

      $element.mediaelementplayer
        startVolume: if $element.data('mute') is true then 0.0 else 0.3
        loop: $element.data('loop')
        alwaysShowControls: $element.data('controls')
        features: ['playpause', 'progress', 'current', 'duration', 'tracks', 'volume', 'fullscreen', 'logo']
        logo:
          text: gon.site_title,
          link: gon.root_url
        success: (mediaelement, domObject, player) ->
          # Variables
          if gon.picture_in_picture
            pipc = new PictureInPicture(mediaelement, player, $('.post__videos'))
            pipc.set_offset()

            # Listeners
            if isLargeUp()
              mediaelement.addEventListener 'playing', (e) ->
                picture_in_picture(pipc)

          mediaelement.addEventListener 'ended', (e) ->
            remove_darkness() if turn_off_the_light
            pipc.undo() if gon.picture_in_picture

          mediaelement.addEventListener 'pause', (e) ->
            remove_darkness() if turn_off_the_light

          mediaelement.addEventListener 'play', (e) ->
            create_darkness() if turn_off_the_light && !$('#shadow').hasClass('night') || (gon.picture_in_picture && !pipc.is_pip() && $('#picture_in_picture .mejs-video').length == 0)

# Pip <audio> or <video> in bottom right of page
picture_in_picture = (pipc) ->
  pipc.set_container() unless pipc.has_pip_dom()
  mediaelement = pipc.get_media_element()
  offset = pipc.get_offset()

  $(window).on 'scroll', throttle(( ->
    # Variables
    is_pip = pipc.is_pip()
    is_paused = mediaelement.paused
    should_pip = $(window).scrollTop() >= offset

    if should_pip && !is_pip && !is_paused
      pipc.append_media()
      mediaelement.play()
      pipc.set_pip(true)
    else if !should_pip && is_pip
      pipc.undo()
      mediaelement.play() unless is_paused
      pipc.set_pip(false)
  ), 500)

# Set dark background
create_darkness = (sel=$('#shadow'), klass='night') ->
  sel.css('height', $(document).outerHeight()).hide()
  sel.addClass(klass).fadeIn(200)
  return

# Remove dark background
remove_darkness = (sel=$('#shadow'), klass='night') ->
  sel.fadeOut 200, ->
    $(@).removeClass(klass)
    $(@).css 'height', 0
    return
