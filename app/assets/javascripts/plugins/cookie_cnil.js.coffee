$(document).on 'ready page:load page:restore', ->
  if Cookies.get('cookiebar_cnil') is undefined and !gon.disable_cookie_message
    $('body').append(
      "<div class='callout cookie_cnil' id='cookie_cnil' data-closable>
        <p>#{I18n.t('cookie_cnil.content')}</p>

        <p class='cookie_choices'>
          <a href='#'>#{I18n.t('cookie_cnil.more_info')}</a>

          <span class='button cookie_btn' id='cookie_accept'>
            #{I18n.t('cookie_cnil.accept')}
          </span>
        </p>

        <button class='close-button' id='cookie_cancel' aria-label='#{I18n.t('close')} / #{I18n.t('cookie_cnil.cancel')}' type='button' data-close>
          <span aria-hidden='true'>&times;</span>
        </button>
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
