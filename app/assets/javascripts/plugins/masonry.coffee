$(document).on 'ready page:load page:restore', ->
  if $('#masonry-container').length > 0 && !isSmall()
    $('#masonry-container').masonry
      itemSelector: '.masonry-item'
