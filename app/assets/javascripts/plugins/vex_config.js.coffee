$(document).on 'ready page:load page:restore', ->
  vex.defaultOptions.className = 'vex-theme-os'
  vex.dialog.buttons.YES.text  = gon.vex_yes_text
  vex.dialog.buttons.NO.text   = gon.vex_no_text