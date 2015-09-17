$(document).on 'ready page:load page:restore', ->
  if $('#calendar').length
    $('#calendar').fullCalendar
      theme: false
      events: gon.event_path