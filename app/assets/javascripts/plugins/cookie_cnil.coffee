$(document).on 'ready page:load page:restore', ->
  if Cookies.get('cookiebar_cnil') is undefined and !gon.disable_cookie_message
    expiration = 30 * 13
    $('body').append(gon.cookies_template)

    # Accept cookies
    $('#cookie_accept').on 'click', (e) ->
      e.preventDefault()
      $('#cookie_cnil').fadeOut()
      Cookies.set('cookiebar_cnil', 'viewed', { expires: expiration })
      Turbolinks.visit(window.location.href)

    # Cancel cookies
    $('#cookie_cancel').on 'click', (e) ->
      e.preventDefault()
      $('#cookie_cnil').fadeOut()
      Cookies.set('cookiebar_cnil', 'viewed', { expires: expiration })
      Cookies.set('cookie_cnil_cancel', '1', { expires: expiration })
