$(document).on 'ready page:load page:restore', ->
  if $('#map:not(.from-form').length
    map = MapBoxSingleton.get(gon.mapbox_access_token, gon.mapbox_username, gon.mapbox_key)
    map.set_view(gon.latitude, gon.longitude)
    map.remove_existing_layers()
    map.set_marker(gon.latitude, gon.longitude)
    map.open_marker()
    map.disable_touch_zoom()
    map.disable_dragging()
