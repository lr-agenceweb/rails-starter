$ ->
  if $('fieldset#referencement').length
    $('fieldset#referencement textarea').each ->
      $textarea = $(this)
      max_count = 150
      current_count = get_count($textarea, max_count)

      $("<p class='counter right'>#{i18n_count(current_count)}</p>").insertBefore($textarea)

      $textarea.keyup ->
        current_count = get_count($(this), max_count)
        $textarea.parent().parent().find('.counter').html(i18n_count(current_count))

get_count = ($textarea, max_count) ->
  current_count = max_count - $textarea.val().length
  current_count = 0 if current_count < 0
  return current_count
i18n_count = (count) ->
  return I18n.t('form.counter', count: count, locale: 'fr')
