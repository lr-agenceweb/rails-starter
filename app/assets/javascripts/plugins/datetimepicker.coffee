$(document).on 'ready page:load page:restore', ->
  $.datetimepicker.setLocale('fr')

  items = [
    {
      $start: $('#blog_publication_date_attributes_published_at'),
      $end: $('#blog_publication_date_attributes_expired_at')
    },
    {
      $start: $('#event_start_date'),
      $end: $('#event_end_date')
    }
  ]

  $.each items, (key, item) ->
    item.$start.datetimepicker
      onShow: (ct) ->
        @setOptions maxDate: if item.$end.val() then item.$end.val() else false
        return
    item.$end.datetimepicker
      onShow: (ct) ->
        @setOptions minDate: if item.$start.val() then item.$start.val() else 0
        return
    return
