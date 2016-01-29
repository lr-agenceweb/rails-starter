$(document).on 'ready page:load page:restore', ->
  vex.defaultOptions.className = 'vex-theme-plain'
  vex.dialog.buttons.YES.text  = I18n.t('true', locale: gon.language)
  vex.dialog.buttons.NO.text   = I18n.t('false', locale: gon.language)

  $('.comment-not-signalled a').on 'click', (e) ->
    e.preventDefault()
    $link = $(this)
    vex.dialog.confirm
      message: $link.data('vex-alert')
      buttons: [
        $.extend({}, vex.dialog.buttons.YES, text: I18n.t('true', locale: gon.language))
        $.extend({}, vex.dialog.buttons.NO, text: I18n.t('false', locale: gon.language))
      ]
      callback: (value) ->
        window.location.href = $link.attr 'href' if value is true