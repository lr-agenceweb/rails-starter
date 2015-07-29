$(document).on 'ready page:load page:restore', ->
  vex.defaultOptions.className = 'vex-theme-os'
  vex.dialog.buttons.YES.text  = I18n.t('delete.yes', locale: gon.language)
  vex.dialog.buttons.NO.text   = I18n.t('delete.no', locale: gon.language)