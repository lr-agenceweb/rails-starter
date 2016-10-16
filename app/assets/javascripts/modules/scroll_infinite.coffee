$(document).on 'ready page:load page:restore', ->

  # Scroll infinite for posts or comments
  $pagination = $('.pagination:not(.no-scroll-infinite)')
  if $pagination.length
    $(window).on 'scroll', throttle(((e) ->
      url = $pagination.find('.next a').attr('href')
      if url && $(window).scrollTop() > ($(document).height() - $(window).height() - 50)
        $pagination.text(I18n.t('scroll_infinite.fetch_nexts'))
        $.getScript(url).done((script, textStatus) ->
          plugins_reflow()
          return
        )
      return
    ), 100)
    $(window).scroll()

plugins_reflow = ->
  friendly_date()
  magnific_popup_init()
  $('.fotorama').fotorama() if $('.fotorama').length > 0
  $('[data-tooltip=""]').foundation() if $('[data-tooltip=""]').length > 0
