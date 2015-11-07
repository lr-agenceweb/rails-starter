$(document).on 'ready page:load page:restore', ->
  I18n.fallbacks = true
  if Cookies.get('cookiebar_cnil') is undefined and !gon.disable_cookie_message
    $('body').append(
      "<div class='cookie_cnil' id='cookie_cnil'>
        #{I18n.t('cookie_cnil.content', locale: gon.language) }
        <div class='cookie_btn' id='cookie_accept'>#{I18n.t('cookie_cnil.accept', locale: gon.language)}</div>
        <div class='cookie_btn cookie_btn-error' id='cookie_cancel'>#{I18n.t('cookie_cnil.cancel', locale: gon.language)}</div>
      </div>"
    )

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