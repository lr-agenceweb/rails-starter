#= require vendor/modernizr
#= require jquery
#= require jquery_ujs
#= require jquery-ui/autocomplete
#= require foundation/foundation
#= require foundation
#= require plugins/foundation_init
#= require turbolinks
#= require nprogress
#= require nprogress-turbolinks
#= require rails.validations
#= require rails.validations.simple_form
#= require rails.validations.simple_form.fix
#= require i18n
#= require i18n/translations
#= require js.cookie
#= require vex.combined.min.js
#= require plugins/vex_config
#= require classes/social_share_class
#= require mapbox
#= require plugins/mapbox
#= require magnific-popup
#= require jquery.autosize
#= require globals/_functions
#= require modules/responsive_menu
#= require modules/autocomplete_search
#= require plugins/nprogress
#= require plugins/cookie_ie
#= require plugins/cookie_adult_validation
#= require plugins/orbit
#= require base/flash
#= require outdatedbrowser/outdatedBrowser
#= require outdated_browser
#= require jquery.sticky_footer

$(document).on 'ready page:load page:restore', ->
  $.rails.allowAction = (link) ->
    return true unless link.attr('data-confirm')
    $.rails.showConfirmDialog(link) # look bellow for implementations
    false # always stops the action since code runs asynchronously

  $.rails.confirmed = (link) ->
    link.removeAttr('data-confirm')
    link.trigger('click.rails')


  $.rails.showConfirmDialog = (link) ->
    vex.dialog.confirm
      message: link.data('confirm')
      callback: (value) ->
        $.rails.confirmed(link) if value is true


  $('.autosize').autosize()

  $('.magnific-popup').magnificPopup
    type: 'image'
    # image:
    #   titleSrc: (item) ->
    #     return item.el.attr('title')

