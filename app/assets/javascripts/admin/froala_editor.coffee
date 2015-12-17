#= require froala_editor.min.js
#= require plugins/block_styles.min.js
#= require plugins/colors.min.js
#= require plugins/media_manager.min.js
#= require plugins/tables.min.js
#= require plugins/video.min.js
#= require plugins/font_family.min.js
#= require plugins/font_size.min.js
#= require plugins/file_upload.min.js
#= require plugins/lists.min.js
#= require plugins/char_counter.min.js
#= require plugins/fullscreen.min.js
#= require plugins/urls.min.js
#= require plugins/inline_styles.min.js
#= require langs/fr.js

$ ->
  if $('.froala').length
    $.Editable.DEFAULTS.key = gon.froala_key
    froala_init()

froala_init = ->
  $('.froala').editable
    inlineMode: false
    placeholder: I18n.t('form.placeholder.froala', locale: gon.language)
    theme: 'red',
    plainPaste: true
    toolbarFixed: false
    tabSpaces: true
    # buttons: ['undo', 'redo' , 'sep', 'bold', 'italic', 'underline', 'createLink', 'blockStyle', 'indent', 'outdent', 'align', 'insertOrderedList', 'insertUnorderedList', 'html']
    language: 'fr'
    minHeight: if $('.froala.small-height').length then null else 300
    height: if $('.froala.small-height').length then 250 else null
    colorsStep: 6