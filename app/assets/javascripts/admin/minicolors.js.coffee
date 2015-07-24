$ ->
  if $('input.colorpicker').length
    $('input.colorpicker').minicolors
      opacity: true
      inline: true

    $this = $('#category_custom_background_color')

    unless $this.is(':checked')
      $('#category_color_input').hide()

    $this.on 'click', (e) ->
      if $this.is(':checked')
        $('#category_color_input').slideDown()
      else
        $('#category_color_input').slideUp()
