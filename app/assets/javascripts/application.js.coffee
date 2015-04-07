#= require vendor/modernizr
#= require jquery
#= require jquery_ujs
#= require foundation/foundation
#= require foundation
#= require turbolinks
#= require nprogress
#= require nprogress-turbolinks
#= require rails.validations
#= require rails.validations.simple_form
#= require rails.validations.simple_form.fix
#= require awesome-share-buttons
#= require mapbox
#= require jquery.autosize
#= require jquery.sticky_footer
#= require globals/_functions
#= require modules/responsive_menu
#= require plugins/mapbox
#= require plugins/nprogress

$(document).on 'ready page:load page:restore', ->
  $(document).foundation
  $('.autosize').autosize()