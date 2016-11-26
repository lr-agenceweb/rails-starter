App.comment = App.cable.subscriptions.create 'CommentChannel',
  connected: ->
    # Called when the subscription has been started by the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
