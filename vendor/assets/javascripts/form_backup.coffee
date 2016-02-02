$.fn.formBackup = ->
  return false if !localStorage

  forms = this
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
    datas[$(this).attr('id')] = $(this).val()
    localStorage.setItem 'formBackup', JSON.stringify(datas)

  forms.on 'click', (e) ->
    $submit = $(this).find('button[type="submit"]')
    window.ClientSideValidations.callbacks.form.pass = ($element, callback) ->
      $submit.prev().fadeIn()
      localStorage.removeItem 'formBackup'
      $(this).resetClientSideValidations()