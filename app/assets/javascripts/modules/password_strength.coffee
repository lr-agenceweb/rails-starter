$(document).on 'ready page:load page:restore', ->
  if show_password_strength()
    instructions = I18n.t('password.instructions', locale: 'fr')
    $('#user_password').parents('.input.password').prepend("<p id='password_instructions'>#{instructions}</p>")

    $('#user_password').parent().append("<div id='password_strength'></div>")
    $('#user_password').keyup (e) ->
      val = $(@).val()
      strongRegex = new RegExp('^(?=.{8,})(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*\\W).*$', 'g')
      mediumRegex = new RegExp('^(?=.{7,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$', 'g')
      enoughRegex = new RegExp('(?=.{6,}).*', 'g')

      if strongRegex.test(val)
        $(@).removeClass().addClass('inline-strong')
        $('#password_strength').html "<span class='strong'>#{I18n.t('password.strong', locale: 'fr')}</span>"
      else if mediumRegex.test(val)
        $(@).removeClass().addClass('inline-medium')
        $('#password_strength').html "<span class='medium'>#{I18n.t('password.medium', locale: 'fr')}</span>"
      else
        $(@).removeClass().addClass('inline-weak')
        $('#password_strength').html "<span class='weak'>#{I18n.t('password.weak', locale: 'fr')}</span>"
      true

show_password_strength = ->
  $('#registration_new').length || $('#user_reset_password_token').length || $('#edit_user').length
