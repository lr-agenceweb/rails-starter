#
# == EasterEgg
#
class @EasterEgg
  @konami = false
  @audio = null
  @timer = null

  constructor: () ->
    @konami = false

  # Create magic :)
  enjoy_easter_egg: ->
    url = if gon.language == 'fr' then '/accueil/easter-egg' else '/en/home/easter-egg'
    $.get url, {}, (data) =>
      $('#easter-egg').html(data).fadeIn(500)
      @audio = $('audio#easter-egg-audio')
      this.epic_music()
      this.mute_button()
      this.close_easter_egg_after_timeout()
      this.close_easter_egg_after_click_escape()
      this.close_easter_egg_after_click_close()

  # Start Epic Star Wars music
  epic_music: ->
    @audio[0].addEventListener 'canplaythrough', (=>
      @audio[0].volume = 0.1
      @audio[0].play()
      return
    ), false
    return

  # Toggle mute sound
  mute_button: ->
    $('#mute-easter-egg').on 'click', (e) =>
      $this = $(e.currentTarget)
      if $this.data('sound') is 'on'
        @audio[0].volume = 0
        $this.data('sound', 'off')
        $this.find('.fa').addClass('fa-volume-off').removeClass('fa-volume-up')
      else
        @audio[0].volume = 0.1
        $this.data('sound', 'on')
        $this.find('.fa').addClass('fa-volume-up').removeClass('fa-volume-off')

  # Close easter egg after timeout
  close_easter_egg_after_timeout: ->
    @timer = setTimeout (=>
      this.close_easter_egg(@audio)
      return
    ), 74000

  # Escape key #accessibilty
  close_easter_egg_after_click_escape: ->
    $(document).keyup (e) =>
      if e.keyCode == 27
        this.close_easter_egg(@audio)
        clearTimeout(@timer)
      return

  # Click on close icon
  close_easter_egg_after_click_close: ->
    $('#easter-egg, #close-easter-egg').on 'click', (e) =>
      return if ($(e.target).is('#mute-easter-egg *'))
      this.close_easter_egg()
      clearTimeout(@timer)

  # Close eater egg
  close_easter_egg: ->
    $('#easter-egg').fadeOut 500, =>
      this.stop_audio_source()
      $(this).empty()
      @konami = false

  # Stop music playing
  stop_audio_source: ->
    @audio[0].pause()

  set_konami: (value) ->
    @konami = value
  get_konami: ->
    return @konami
