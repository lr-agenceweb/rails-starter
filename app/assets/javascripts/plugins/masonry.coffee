$(document).on 'ready page:load page:restore', ->
  $('#masonry-container').masonry
    itemSelector: '.masonry-item'
