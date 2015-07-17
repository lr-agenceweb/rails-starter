$(document).on 'ready page:load page:restore', ->
  if gon.adult_validation is true and Cookies.get('adult') is undefined
    vex.dialog.confirm
      message: 'Vous devez être majeur pour accéder à ce site. En cliquant sur valider, vous attestez sur l\'honneur avoir plus de 18 ans'
      callback: (value) ->
        window.location.href = 'http://google.fr' if value is false
        Cookies.set('adult', 'validated') if value is true