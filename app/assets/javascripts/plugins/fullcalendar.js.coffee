#= require moment
#= require moment/en-gb
#= require fullcalendar
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

      # Callbacks
      viewRender: (view, element) ->
        setTimeout ->
          highlight_current_day()
        , 2000

      eventAfterAllRender: (view) ->
        disable_calendar_navigation(view) if gon.single_event

      eventRender: (event, element, view) ->
        $title = $(element).find('.fc-list-item-title a')
        opts = {
          tipText: event.cover,
          templateClasses: 'custom',
          allowHtml: true
        }
        new Foundation.Tooltip($title, opts)
        return element

    # Refresh calendar when opening Foundation modal box
    $('#fullcalendar__modal').on 'open.zf.reveal', ->
      setTimeout ->
        $calendar = $('#calendar')
        $calendar.fullCalendar 'render'
        $calendar.fullCalendar('gotoDate', gon.start_event) if gon.single_event
      , 300


# Highlight current panel day
highlight_current_day = ->
  $('.fc-list-heading').each (index) ->
    $this = $(@)
    if $this.attr('data-date') == moment().format('YYYY-MM-DD')
      $this.find('.fc-widget-header').addClass('current-day')
    return

# Disable prev / next Fullcalendar navigation
disable_calendar_navigation = (view) ->
  minDate = moment(gon.start_event)
  maxDate = moment(gon.end_event)
  maxDate = minDate unless maxDate.isValid()

  # Past
  if minDate >= view.start and minDate <= view.end
    $('.fc-prev-button').prop 'disabled', true
    $('.fc-prev-button').addClass 'fc-state-disabled'
  else
    $('.fc-prev-button').removeClass 'fc-state-disabled'
    $('.fc-prev-button').prop 'disabled', false

  # Future
  if maxDate >= view.start and maxDate <= view.end
    $('.fc-next-button').prop 'disabled', true
    $('.fc-next-button').addClass 'fc-state-disabled'
  else
    $('.fc-next-button').removeClass 'fc-state-disabled'
    $('.fc-next-button').prop 'disabled', false
  return
