#= require active_admin/base
#= require activeadmin-sortable
#= require jquery-ui
#= require chosen-jquery
#= require admin/form_translation
#= require admin/froala_editor
#= require admin/settings
#= require admin/chosen
#= require admin/newsletters_preview
#= require gmaps.js
#= require globals/_functions
#= require mapbox
#= require plugins/mapbox
#= require vex.combined.min.js

$(document).on 'ready page:load page:restore', ->
  vex.defaultOptions.className = 'vex-theme-os'
