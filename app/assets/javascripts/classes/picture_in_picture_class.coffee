#
# PictureInPicture class
# ================
class @PictureInPicture
  offset: 0

  constructor: (@mediaelement, @player) ->

  set_container: ->
    $('body').append($('<div id="picture_in_picture" class="picture_in_picture" />'))

  has_pip_dom: ->
    return $('#picture_in_picture').length > 0

  append_media_to_pip: ->
    $('#picture_in_picture').append(@.get_me_player())

  remove_media_from_pip: ($container) ->
    $container.append(@.get_me_player())

  get_media_element: ->
    return @mediaelement

  get_me_player: ->
    return $(@player.container[0]).parent()

  set_me_player_offset: ->
    @offset = @.get_me_player().offset().top - 120

  get_me_player_offset: ->
    return @offset
