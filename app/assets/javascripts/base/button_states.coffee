#
# Button States
# =============
$(document).on 'ready page:load page:restore', ->
  buttons_state_listener()

# Set button state depending on form callback
@buttons_state_listener = ->
  if $('button[type="submit"]').length > 0
    $('.button-state').parents('form').on 'click', (e) ->
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

        reset_local_storage($this)

      # Fail
      window.ClientSideValidations.callbacks.form.fail = (form, eventData) ->
        if $submit.hasClass 'button-state'
          $submit.addClass(error_classes).removeClass(base_classes).removeClass(pending_classes)
          $submit.text I18n.t('button_states.error')


# Set 'success' state for submit button (from js.erb)
@submit_btn_state = (id, label) ->
  $submit = $("#{id} button[type='submit']")
  $submit.addClass('success fa-check').removeClass('warning pulse fa-spinner')
  $submit.text(label)

@reset_local_storage = (form) ->
  localStorage.removeItem 'formBackup'
  form.resetClientSideValidations()
