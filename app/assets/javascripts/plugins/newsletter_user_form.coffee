$(document).on 'ready page:load page:restore', ->
  $('.newsletter-form__button').on 'click', (e) ->
    $this = $(@)
    $form = $this.parents('form')
    $fa = $this.find('.fa')
    icon = $this.attr('data-icon')

    # Before
    $('#newsletter-form__feedback .form--success').addClass('hide')
    $('#newsletter-form__feedback .form--error').addClass('hide')

    # Pending
    $this.addClass('warning')
    $fa.addClass('fa-spinner')

    # Success
    window.ClientSideValidations.callbacks.form.pass = (form, eventData) ->
      $this.removeClass('warning alert').addClass('success')
      $fa.removeClass("#{icon} fa-spinner fa-times").addClass('fa-check')

    # Fail
    window.ClientSideValidations.callbacks.form.fail = (form, eventData) ->
      $this.removeClass('warning').addClass('alert')
      $fa.removeClass("#{icon} fa-spinner").addClass('fa-times')
