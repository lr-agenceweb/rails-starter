#= require magnific-popup

$(document).on 'ready page:load page:restore', ->
  magnific_popup_init()

@magnific_popup_init = ->
  $('.magnific-popup').magnificPopup
    type: 'image'
    image:
      titleSrc: (item) ->
        return item.el.attr('title')
