$ ->
  if $('fieldset#referencement').length
    $('fieldset#referencement textarea').each ->
      $textarea = $(this)
      $textarea.keyup ->
        left = 150 - $(this).val().length
        left = 0 if (left < 0)

        $textarea.parent().parent().find('.counter').html(I18n.t('form.counter', count: left, locale: 'fr'))
