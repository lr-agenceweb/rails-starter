$ ->
  # Event :: hide end_date input if all_day is checked
  if $('#event_all_day').length
    $all_day = $('#event_all_day')
    $('#event_end_date_input').hide() if $all_day.is(':checked')

    $all_day.on 'click', (e) ->
      if $(this).is(':checked')
        $('#event_end_date_input').slideUp()
      else
        $('#event_end_date_input').slideDown()
