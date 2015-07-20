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
    froala_init()

froala_init = ->
  $('.froala').editable
    inlineMode: false
    placeholder: 'Contenu de l\'article ici :)'
    theme: 'gray',
    plainPaste: true
    toolbarFixed: false
    tabSpaces: true
    # buttons: ['undo', 'redo' , 'sep', 'bold', 'italic', 'underline', 'createLink', 'blockStyle', 'indent', 'outdent', 'align', 'insertOrderedList', 'insertUnorderedList', 'html']
    language: 'fr'
    minHeight: 300
    colorsStep: 6