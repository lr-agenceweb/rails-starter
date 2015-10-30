$(document).on 'ready page:load page:restore', ->
  easter_egg = new Konami ->
    $.get '/homes/easter-egg', {}, (data) ->
      $('#easter-egg').html(data).fadeIn(500)

      $('#easter-egg, #close-easter-egg').on 'click', ->
        $(this).fadeOut 500, ->
          $(this).empty()
