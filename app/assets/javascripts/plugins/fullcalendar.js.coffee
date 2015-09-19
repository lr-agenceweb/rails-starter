$(document).on 'ready page:load page:restore', ->
  if $('#calendar').length
    $('#calendar').fullCalendar
      theme: true
      events: gon.event_path
      firstDay: 1
      lang: gon.language
      height: 'auto'