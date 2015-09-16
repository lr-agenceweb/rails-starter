$(document).on 'ready page:load page:restore', ->
  if $('#calendar').length
    $('#calendar').fullCalendar()