$ ->
  if ('#omniauth_facebook').length
    $('#omniauth_facebook').on 'click', (e) ->
      e.preventDefault()
      $link = $(@)
      vex.dialog.confirm
        message: "<h3>#{I18n.t('omniauth.link', provider: 'Facebook', locale: 'fr')}</h3> #{I18n.t('omniauth.message', locale: 'fr')}"
        callback: (value) ->
          window.location.href = $link.attr 'href' if value is true
