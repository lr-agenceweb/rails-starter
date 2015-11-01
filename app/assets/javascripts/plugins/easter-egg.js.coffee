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

enjoy_easter_egg = ->
  $.get '/homes/easter-egg', {}, (data) ->

    $('#easter-egg').html(data).fadeIn(500)
    $audio = $('audio#easter-egg-audio')
    epic_music($audio)

    timer = setTimeout (->
      close_easter_egg($audio)
      return
    ), 74000

    $('#easter-egg, #close-easter-egg').on 'click', ->
      close_easter_egg($audio)
      clearTimeout(timer)

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
