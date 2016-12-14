$(document).on 'ready page:load page:restore', ->
  #
  # Event
  # (hide end_date input if all_day is checked)
  #
  if $('#event_all_day').length > 0
    $all_day = $('#event_all_day')
    $('#event_end_date_input').hide() if $all_day.is(':checked')

    $all_day.on 'click', (e) ->
      if $(this).is(':checked')
        $('#event_end_date_input').slideUp()
      else
        $('#event_end_date_input').slideDown()

  #
  # PublicationDate [Blog]
  # (set published_at and expired_at input)
  #
  scope = '#blog_publication_date_attributes'
  attrib = [
    { bool: 'published_later', input: 'published_at' },
    { bool: 'expired_prematurely', input: 'expired_at' }
  ]

  for publication in attrib
    if $("#{scope}_#{publication.bool}").length > 0
      $boolean = $("#{scope}_#{publication.bool}")
      $input = $("#{scope}_#{publication.input}_input")
      $input.hide() unless $boolean.is(':checked')

      $boolean.on 'click', (e) ->
        $li = $(@).parents('li').next('li')
        if $(@).is(':checked')
          $li.slideDown()
        else
          $li.slideUp()
