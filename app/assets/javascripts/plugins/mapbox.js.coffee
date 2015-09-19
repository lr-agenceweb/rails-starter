#= require classes/mapbox_class

$(document).on 'ready page:load page:restore', ->
  map_init()

map_init = ->
  if $('#map:not(.from-form').length
    $('#map').addClass('js-height')
    map = MapBoxSingleton.get(gon.mapbox_access_token, gon.mapbox_username, gon.mapbox_key, true)
    map.set_view(gon.latitude, gon.longitude)
    map.remove_existing_layers()
    map.set_marker(gon.latitude, gon.longitude)
    map.disable_touch_zoom()
    map.disable_dragging()
