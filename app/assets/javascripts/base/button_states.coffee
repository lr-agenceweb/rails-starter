$(document).on 'ready page:load page:restore', ->
  if $('button[type="submit"]').length > 0
    $('form').on 'click', (e) ->
      $this = $(@)
      $submit = $this.find('button[type="submit"]')
      base_classes = 'fa-paper-plane'
      pending_classes = 'warning pulse fa-spinner'
      error_classes = 'alert fa-times'

      # Success
      window.ClientSideValidations.callbacks.form.pass = (form, eventData) ->
        if $submit.hasClass 'button-state'
          $submit.addClass(pending_classes).removeClass(base_classes).removeClass(error_classes)
          $submit.text I18n.t('button_states.pending')
        else
          $submit.prev().fadeIn()

        localStorage.removeItem 'formBackup'
        $this.resetClientSideValidations()

      # Fail
      window.ClientSideValidations.callbacks.form.fail = (form, eventData) ->
        if $submit.hasClass 'button-state'
          $submit.addClass(error_classes).removeClass(base_classes).removeClass(pending_classes)
          $submit.text I18n.t('button_states.error')
