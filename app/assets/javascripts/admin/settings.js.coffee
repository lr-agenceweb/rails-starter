$ ->
  if $('#setting_show_map').length
    $this = $('#setting_show_map')

    if $this.is(':checked')
    else
      $('.map-settings').hide()

    $this.on 'click', (e) ->
      if $this.is(':checked')
        $('.map-settings').slideDown()
      else
        $('.map-settings').slideUp()
