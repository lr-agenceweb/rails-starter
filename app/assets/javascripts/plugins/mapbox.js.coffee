#= require classes/mapbox_class

$(document).on 'ready page:load page:restore', ->
  if $('#map:not(.from-form):not(.map__modal__map)').length
    map_init()

  #
  # Modal
  # =====
  map = null
  $('.map__modal').on 'open.zf.reveal', ->
    map = map_init()
  $('.map__modal').on 'closed.zf.reveal', ->
    map.destroy_map()

map_init = ->
  $('#map').addClass('js-height')
  map = MapBoxSingleton.get(gon.mapbox_access_token, gon.mapbox_username, gon.mapbox_key, true)

  latitude = $('#map').attr('data-latitude') || gon.latitude
  longitude = $('#map').attr('data-longitude') || gon.longitude
  symbol = $('#map').attr('data-symbol') || gon.marker_icon
  popup = $('#map').attr('data-popup') || true

  map.set_view(latitude, longitude)
  map.remove_existing_layers()
  map.set_marker(latitude, longitude, symbol, $.parseJSON(popup))
  map.disable_touch_zoom()
  map.disable_dragging()

  return map
