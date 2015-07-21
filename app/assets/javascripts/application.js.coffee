#= require vendor/modernizr
#= require jquery
#= require jquery_ujs
#= require jquery-ui/autocomplete
#= require foundation/foundation
#= require foundation
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
#= require jquery.slick
#= require awesome-share-buttons
#= require plugins/awesome-share-buttons
#= require mapbox
#= require jquery.autosize
#= require globals/_functions
#= require modules/responsive_menu
#= require modules/autocomplete_search
#= require plugins/mapbox
#= require plugins/nprogress
#= require plugins/cookie_ie
#= require plugins/cookie_adult_validation
#= require base/flash
#= require outdatedbrowser/outdatedBrowser
#= require outdated_browser
#= require jquery.sticky_footer

$(document).on 'ready page:load page:restore', ->
  $('.autosize').autosize()

  if $('.slick-carousel').length
    console.log gon

    $('.slick-carousel').slick
      slidesToShow: 1
      dots: gon.bullet
      autoplay: gon.autoplay
      infinite: gon.loop
      fade: if gon.animate == 'fade' then true else false
      pauseOnHover: gon.hover_pause
      pauseOnDotsHover: gon.hover_pause
      speed: gon.timeout
      autoplaySpeed: gon.timeout
      arrows : gon.navigation
      # lazyLoad: true
