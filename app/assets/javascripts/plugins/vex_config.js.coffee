$(document).on 'ready page:load page:restore', ->
  vex.defaultOptions.className = 'vex-theme-plain'
  vex.dialog.buttons.YES.text  = I18n.t('true')
  vex.dialog.buttons.NO.text   = I18n.t('false')
