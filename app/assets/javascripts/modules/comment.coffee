$(document).on 'ready page:load page:restore', ->
  comment_reply_loader() # Set listener for 'Spinner' image
  comment_reply_close() # Set listener for 'Close' button

comment_reply_loader = ->
  $('.comment-reply').on 'click', (e) ->
    $(this).find('.spinner').removeClass('hide')

comment_reply_close = ->
  $(document).on 'click', '.reply-form-close', (e) ->
    $this = $(@)
    $this.parent().fadeOut(200, ->
      $this.remove()
    )
