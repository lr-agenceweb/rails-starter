###
## Easter Egg ##
###

# Haut, haut, bas, bas, gauche, droite, gauche, droite, B, A
k = [38, 38, 40, 40, 37, 39, 37, 39, 66, 65]
n = 0
root = exports ? this
root.konami = false

$(document).keydown (e) ->
  if e.keyCode == k[n++] && root.konami == false
    if n == k.length
      root.konami = true
      enjoy_easter_egg()
      n = 0
      return
  else
    n = 0
  return

# Create magic :)
enjoy_easter_egg = ->
  $.get '/homes/easter-egg', {}, (data) ->

    $('#easter-egg').html(data).fadeIn(500)
    $audio = $('audio#easter-egg-audio')
    epic_music($audio)
    mute_button($audio)

    timer = setTimeout (->
      close_easter_egg($audio)
      return
    ), 74000

    # Click on close icon
    $('#easter-egg, #close-easter-egg').on 'click', (e) ->
      return if ($(e.target).is('#mute-easter-egg *'))
      close_easter_egg($audio)
      clearTimeout(timer)

    # Escape key #accessibilty
    $(document).keyup (e) ->
      if e.keyCode == 27
        close_easter_egg($audio)
        clearTimeout(timer)
      return

# Toggle mute sound
mute_button = (audio) ->
  $('#mute-easter-egg').on 'click', (e) ->
    e.preventDefault()
    $this = $(this)
    if $this.data('sound') is 'on'
      audio[0].volume = 0
      $this.data('sound', 'off')
      $this.find('.fa').addClass('fa-volume-off').removeClass('fa-volume-up')
    else
      audio[0].volume = 0.1
      $this.data('sound', 'on')
      $this.find('.fa').addClass('fa-volume-up').removeClass('fa-volume-off')

# Close eater egg
close_easter_egg = (audio) ->
  $('#easter-egg').fadeOut 500, ->
    stop_audio_source(audio)
    $(this).empty()
    root.konami = false

# Start Epic Star Wars music
epic_music = (audio) ->
  audio[0].addEventListener 'canplaythrough', (->
    this.volume = 0.1
    audio[0].play()
    return
  ), false
  return

# Stop and remove audio source
stop_audio_source = (audio) ->
  audio[0].pause()
