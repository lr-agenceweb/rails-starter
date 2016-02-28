$.fn.formBackup = ->
  return false if !localStorage

  forms = @
  datas = {}
  ls = false
  datas.href = window.location.href

  # Get localStorage informations
  if localStorage['formBackup']
    ls = JSON.parse localStorage['formBackup']

    if ls.href == datas.href
      for id of ls
        if id != 'href'
          $('#'+id).val ls[id]
          datas[id] = ls[id]

  forms.find('input, textarea').keyup (e) ->
    datas[$(@).attr('id')] = $(@).val()
    localStorage.setItem 'formBackup', JSON.stringify(datas)

  forms.on 'click', (e) ->
    $submit = $(@).find('button[type="submit"]')
    window.ClientSideValidations.callbacks.form.pass = ($element, callback) ->
      $submit.prev().fadeIn()
      localStorage.removeItem 'formBackup'
      forms.resetClientSideValidations()