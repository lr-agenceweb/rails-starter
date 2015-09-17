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
#= require plugins/override_rails_confirm
#= require classes/social_share_class
#= require mapbox
#= require plugins/mapbox
#= require magnific-popup
#= require fotorama
#= require moment
#= require fullcalendar
#= require fullcalendar/lang/fr
#= require jquery.autosize
#= require globals/_functions
#= require modules/responsive_menu
#= require modules/autocomplete_search
#= require plugins/nprogress
#= require plugins/cookie_ie
#= require plugins/cookie_adult_validation
#= require plugins/fotorama
#= require plugins/fullcalendar
#= require base/flash
#= require outdatedbrowser/outdatedBrowser
#= require outdated_browser
#= require jquery.sticky_footer

$(document).on 'ready page:load page:restore', ->
  $('.autosize').autosize()

  $('.magnific-popup').magnificPopup
    type: 'image'
    # image:
    #   titleSrc: (item) ->
    #     return item.el.attr('title')

