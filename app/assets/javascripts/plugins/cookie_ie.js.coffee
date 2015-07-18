$(document).on 'ready page:load page:restore', ->

  if Cookies.get('cookie-ie') is undefined
    $('#btnCloseUpdateBrowser').on 'click', (e) ->
      e.preventDefault()
      Cookies.set('cookie-ie', 'viewed', { expires: 7 })
