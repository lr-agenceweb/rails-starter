$(document).on 'ready page:load page:restore', ->
  if Cookies.get('cookiebar_cnil') is undefined and !gon.disable_cookie_message
    $('body').append(gon.cookies_template)

    # Accept cookies
    $('#cookie_accept').on 'click', (e) ->
      e.preventDefault()
      $('#cookie_cnil').fadeOut()
      Cookies.set('cookiebar_cnil', 'viewed', { expires: 30 * 13 })

    # Cancel cookies
    $('#cookie_cancel').on 'click', (e) ->
      e.preventDefault()
      $('#cookie_cnil').fadeOut()
      Cookies.set('cookiebar_cnil', 'viewed', { expires: 30 * 13 })
      Cookies.set('cookie_cnil_cancel', '1', { expires: 30 * 13 })
