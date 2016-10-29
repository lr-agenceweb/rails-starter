#
# PictureInPicture class
# ================
class @PictureInPicture
  offset: 0
  time_to_wait: 1000

  constructor: (@mediaelement, @player) ->

  set_container: ->
    $('body').append($('<div id="picture_in_picture" class="picture_in_picture" />'))

  has_pip_dom: ->
    return $('#picture_in_picture').length > 0

  append_media_to_pip: ->
    $('#picture_in_picture').append(@.get_me_player_container())

  remove_media_from_pip: ($container) ->
    $container.append(@.get_me_player_container())

  get_media_element: ->
    return @mediaelement

  # MediaElement player
  get_me_player_container: ->
    return @.get_me_player().parent()

  get_me_player: ->
    return $(@player.container[0])

  # Offset
  set_me_player_offset: ->
    @offset = @.get_me_player().offset().top - 40

  get_me_player_offset: ->
    return @offset
