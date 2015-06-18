$(document).on 'ready page:load page:restore', ->
  $('a.newsletter_preview_button.existing_record').on 'click', (e) ->
    e.preventDefault()
    preview_newsletter($(this), 'put')

  $('a.newsletter_preview_button.new_record').on 'click', (e) ->
    e.preventDefault()
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
        vex.dialog.alert I18n.t('newsletter.refresh_after_create', locale: 'fr')
        window.location.replace "#{url}/#{data.id}/edit"
      return false
    error: (jqXHR, textStatus, errorThrown) ->
      console.log 'Error'
