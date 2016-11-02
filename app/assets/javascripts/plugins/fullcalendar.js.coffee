#= require moment
#= require moment/en-gb
#= require fullcalendar.3.0.1.min
#= require fullcalendar/lang/fr

$(document).on 'ready page:load page:restore', ->
  if $('#calendar').length
    $('#calendar').fullCalendar
      # Core params
      events: gon.events
      firstDay: 1
      timezone: 'local'

      # Views params
      defaultView: 'listWeek' # basicWeek
      header:
        left:   'today prev,next title',
        center: '',
        right:  ''

      # Other params
      locale: gon.language
      height: 'auto'
      contentHeight: 'auto'
      allDayHtml: I18n.t('event.all_day')

    # Refresh calendar when opening Foundation modal box
    $('#fullcalendar__modal').on 'open.zf.reveal', ->
      setTimeout ->
        $('#calendar').fullCalendar 'render'
      , 300
