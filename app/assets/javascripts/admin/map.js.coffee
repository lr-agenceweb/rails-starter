$ ->
  if $('#map_show_map').length
    $this = $('#map_show_map')
    # init = false

    if $this.is(':checked')
      map_init()
    else
      $('#map-columns').hide()

    $this.on 'click', (e) ->
      if $this.is(':checked')
        $('#map-columns').slideDown()
        map_init()
      else
        $('#map-columns').slideUp()


map_init = ->
  map = MapBoxSingleton.get(gon.mapbox_access_token, gon.mapbox_username, gon.mapbox_key)
  map.set_view(gon.latitude, gon.longitude)
  map.remove_existing_layers()
  map.set_marker(gon.latitude, gon.longitude)
  map.disable_touch_zoom()
  map.disable_dragging()
  refresh_map_with_new_position(map)

refresh_map_with_new_position = (map) ->
  $('#gmaps-output-latitude, #gmaps-output-longitude').on 'change', (e) ->
    sleep 20

    new_lat = $('#gmaps-output-latitude').val()
    new_lon = $('#gmaps-output-longitude').val()

    map.set_view(new_lat, new_lon)
    map.remove_existing_layers()
    map.set_marker(new_lat, new_lon)
