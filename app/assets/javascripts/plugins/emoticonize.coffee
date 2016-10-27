#= require jquery.cssemoticons

$(document).on 'ready page:load page:restore', ->
  emoticonize_me()

@emoticonize_me = ->
  $('.comment .comment__body').emoticonize
    animate: false
