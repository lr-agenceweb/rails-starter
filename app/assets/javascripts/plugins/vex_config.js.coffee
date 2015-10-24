$(document).on 'ready page:load page:restore', ->
  vex.defaultOptions.className = 'vex-theme-plain'
  vex.dialog.buttons.YES.text  = I18n.t('true', locale: gon.language)
  vex.dialog.buttons.NO.text   = I18n.t('false', locale: gon.language)