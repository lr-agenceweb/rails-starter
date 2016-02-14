$(document).on 'ready page:load page:restore', ->
  open = false
  $('.devkit').on 'click', (e) ->
    if !open
      $(@).removeClass('initial').addClass('open')
      open = true
    else
      $(@).removeClass('open').addClass('initial')
      open = false