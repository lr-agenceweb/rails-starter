$(document).on 'ready page:load page:restore', ->
  $submit = $('.search-form .search-form__button')
  $fa = $submit.find('.fa')

  $('#term.autocomplete').autocomplete(
    source: $('#search_form').attr('action')
    minLength: 3
    search: (event, ui) ->
      search_loading($submit, $fa)
      return

    select: (event, ui) ->
      $('#term.autocomplete').val ui.item.title
      search_loading($submit, $fa)
      Turbolinks.visit(ui.item.url)
      return

    response: (event, ui) ->
      if ui['content'].length == 0
        $submit.addClass('alert')
        $fa.addClass('fa-times')
      else
        $fa.addClass('fa-search')

      $submit.removeClass('warning')
      $fa.removeClass('fa-spinner')

      return
  )
  .autocomplete('instance')._renderItemData = (ul, item) ->
    ul.data 'ui-autocomplete-item', item
    image = if item.hasOwnProperty('picture') then '<div class="dtcell"><img src="' + item.picture + '" class="autocomplete__picture polyfill" /></div>' else ''
    $('<li>').data('ui-autocomplete-item', item)
      .append('<div class="dtable">' + image + '<div class="dtcell autocomplete__content"><p>' + item.title + '</p></div></div>').addClass('ui-menu-item').appendTo ul

search_loading = ($submit, $fa) ->
  $submit.addClass('warning').removeClass('alert')
  $fa.removeClass('fa-search fa-times').addClass('fa-spinner')
