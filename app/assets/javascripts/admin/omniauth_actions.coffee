$ ->
  if ('.button.omniauth').length
    $('.button.omniauth').on 'click', (e) ->
      e.preventDefault()
      e.stopPropagation()
      $link = $(@)
      vex.dialog.confirm
        message: "<h3>#{$link.data('vex-title')}</h3> #{$link.data('vex-message')}"
        callback: (value) ->
          if value is true
            if $link.data('method') == 'delete'
              f = document.createElement('form')
              $link.after $(f).attr(
                method: 'post'
                action: $link.attr('href')).append('<input type="hidden" name="_method" value="delete" />')
              $(f).submit()
            else
              window.location.href = $link.attr 'href'
