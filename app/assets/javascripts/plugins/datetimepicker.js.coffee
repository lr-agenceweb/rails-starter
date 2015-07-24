$(document).on 'ready page:load page:restore', ->
  # Dateimepicker
  $start = $('#event_start_date')
  $end = $('#event_end_date')

  if $start.length && $end.length
    $start.datetimepicker
      format:'Y-m-d H:i:s'
      defaultTime:'12:00'
      inline: true,
      timepicker: true
      lang: 'fr'
      value: $start.val()
      scrollMonth: false
      scrollTime: false
      dayOfWeekStart: 1

    $end.datetimepicker
      format:'Y-m-d H:i:s'
      defaultTime:'12:00'
      inline: true,
      timepicker: true
      lang: 'fr'
      value: $end.val()
      scrollMonth: false
      scrollTime: false
      dayOfWeekStart: 1
