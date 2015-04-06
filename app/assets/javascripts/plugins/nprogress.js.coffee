NProgress.configure
  showSpinner: false
  ease: 'ease'
  speed: 500

$(document).on 'page:fetch', ->
  NProgress.start()
  return
$(document).on 'page:change', ->
  NProgress.done()
  return
$(document).on 'page:restore', ->
  NProgress.remove()
  return
