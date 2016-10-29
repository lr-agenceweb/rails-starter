#
# PictureInPicture class
# ================
class @PictureInPicture
  offset: 0
  pip: false
  custom_margin_top: 40

  constructor: (@mediaelement, @player, @container) ->

  #
  # DOM
  # ===
  set_container: ->
    $('body').append($('<div id="picture_in_picture" class="picture_in_picture" />'))

  has_pip_dom: ->
    return $('#picture_in_picture').length > 0

  append_media: ->
    $('#picture_in_picture').append(@.get_me_player_container())
    sticky_sidebar_fix()

  #
  # MediaElement player
  # ===================
  get_media_element: ->
    return @mediaelement

  get_me_player: ->
    return $(@player.container[0])

  get_me_player_container: ->
    return @.get_me_player().parent()

  #
  # PiP
  # ===
  set_pip: (pip) ->
    @pip = pip

  is_pip: ->
    return @pip

  undo: ->
    @container.append(@.get_me_player_container())
    sticky_sidebar_fix()

  #
  # Offset
  # ======
  set_offset: ->
    if $('.fotorama').length > 0
      $('.fotorama').on 'fotorama:ready', (e, fotorama) =>
        @offset = @.calcul_offset()
    else
      @offset = @.calcul_offset()

  get_offset: ->
    return @offset

  calcul_offset: ->
    return @.get_me_player().offset().top - @custom_margin_top
