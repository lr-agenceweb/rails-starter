$(document).on 'ready page:load page:restore', ->
  $(document).foundation()

  $a = $('.awesome-share-buttons').find('a')
  $a.each (index, element) ->
    $this = $(this)
    title = $this.attr 'title'
    $this.attr 'title', ''

    $(element).wrap "<span class='tip-bottom' data-tooltip aria-hashpopup='true' title='#{title}'></span>"
  $(document).foundation 'tooltip', 'reflow'
