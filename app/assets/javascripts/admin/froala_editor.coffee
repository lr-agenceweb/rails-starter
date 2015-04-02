#= require froala_editor.min.js
#= require plugins/lists.min.js
#= require plugins/char_counter.min.js
#= require langs/fr.js

$ ->
  if $('.froala').length
    froala_init()

  $('.button.has_many_add').on 'click', (e) ->
    setTimeout (->
      froala_init()
      return
    ), 150

froala_init = ->
  $('.froala').editable
    inlineMode: false
    placeholder: 'Contenu de l\'article ici :)'
    theme: 'royal',
    plainPaste: true
    toolbarFixed: false
    tabSpaces: true
    buttons: ['undo', 'redo' , 'sep', 'bold', 'italic', 'underline', 'createLink', 'blockStyle', 'indent', 'outdent', 'align', 'insertOrderedList', 'insertUnorderedList', 'html']
    language: 'fr'
    minHeight: 300