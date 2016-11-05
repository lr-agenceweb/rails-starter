$(document).on 'ready page:load page:restore', ->
  $('.fotorama').fotorama()

  $('.fotorama').on 'fotorama:ready', (e, fotorama) ->
    sticky_sidebar_fix()
