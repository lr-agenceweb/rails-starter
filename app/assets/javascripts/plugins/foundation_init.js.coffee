$(document).on 'ready page:load page:restore', ->
  $(document).foundation()

  # Workaround Sticky and Turbolinks
  if $('[data-sticky]').length > 0
    $(window).trigger('load.zf.sticky')
