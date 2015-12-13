$(document).on 'ready page:load page:restore', ->
  alert_before_send_newsletter()

  $('a.newsletter_preview_button.existing_record').on 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()
    preview_newsletter($(this), 'put')

  $('a.newsletter_preview_button.new_record').on 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()
    preview_newsletter($(this), 'post')

# Save form in database, reload the page if creation, refresh the iframe if edition
preview_newsletter = (element, method) ->
  url = element.data 'url'
  $form = $('form.newsletter')
  datas = $form.serialize()

  datas['_method'] = 'put' if method == 'put'

  $.ajax
    url: $form.attr 'action'
    type: 'POST'
    data: datas
    dataType: 'json'
    success: (data) ->
      # Edition
      if method == 'put'
        $('#newsletter_preview_frame').attr 'src', url

      # Creation
      else
        vex.dialog.alert
          message: I18n.t('newsletter.refresh_after_create', locale: 'fr')
          buttons: [
            $.extend({}, vex.dialog.buttons.YES, text: I18n.t('alert.ok', locale: 'fr'))
          ]
          callback: (value) ->
            window.location.replace "#{url}/#{data.id}/edit"
      return false
    error: (jqXHR, textStatus, errorThrown) ->
      console.log 'Error'


# Vex alert before sending newsletter
alert_before_send_newsletter = ->
  $('.vex-alert.newsletter-button').on 'click', (e) ->
    e.preventDefault()
    $link = $(this)
    vex.dialog.confirm
      message: $link.data('vex-alert')
      buttons: [
        $.extend({}, vex.dialog.buttons.YES, text: I18n.t('newsletter.yes', locale: 'fr'))
        $.extend({}, vex.dialog.buttons.NO, text: I18n.t('newsletter.no', locale: 'fr'))
      ]
      callback: (value) ->
        window.location.href = $link.attr 'href' if value is true