$(document).on 'ready page:load page:restore', ->
  $('.magnific-popup').magnificPopup
    type: 'image'
    # image:
    #   titleSrc: (item) ->
    #     return item.el.attr('title')