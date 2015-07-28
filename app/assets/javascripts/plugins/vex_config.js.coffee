$(document).on 'ready page:load page:restore', ->
  vex.defaultOptions.className = 'vex-theme-os'
  vex.dialog.buttons.YES.text  = I18n.t('delete.yes')
  vex.dialog.buttons.NO.text   = I18n.t('delete.no')