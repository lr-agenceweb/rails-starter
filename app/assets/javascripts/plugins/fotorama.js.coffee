$(document).on 'ready page:load page:restore', ->
  $(document).foundation 'interchange', 'reflow'
  $('.fotorama').fotorama()