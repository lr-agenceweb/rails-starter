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
#= require jquery.autosize
#= require globals/_functions
#= require tools/mapbox
#= require tools/nprogress

$(document).on 'ready page:load page:restore', ->
  $(document).foundation
  $('.autosize').autosize()