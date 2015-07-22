$(document).on 'ready page:load page:restore', ->
  $('#term.autocomplete').autocomplete(
    source: gon.search_path
    minLength: 3
    select: (event, ui) ->
      Turbolinks.visit(ui.item.url)
      return
  )
  .autocomplete('instance')._renderItemData = (ul, item) ->
    ul.data 'ui-autocomplete-item', item
    image = if item.hasOwnProperty('picture') then '<div class="dtcell"><img src="' + item.picture + '" /></div>' else ''
    $('<li>').data('ui-autocomplete-item', item)
      .append('<div class="dtable">' + image + '<div class="dtcell autocomplete-content">' + item.title + '</div></div>').addClass('ui-menu-item').appendTo ul
