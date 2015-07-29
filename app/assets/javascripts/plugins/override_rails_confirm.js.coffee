$(document).on 'ready page:load page:restore', ->
  $.rails.allowAction = (link) ->
    return true unless link.attr('data-confirm')
    $.rails.showConfirmDialog(link) # look bellow for implementations
    false # always stops the action since code runs asynchronously

  $.rails.confirmed = (link) ->
    link.removeAttr('data-confirm')
    link.trigger('click.rails')

  $.rails.showConfirmDialog = (link) ->
    vex.dialog.confirm
      message: link.data('confirm')
      callback: (value) ->
        $.rails.confirmed(link) if value is true
