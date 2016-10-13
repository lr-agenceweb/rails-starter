class @MapBoxSingleton
  instance = null

  class MapBoxClass
    @map = null
    @featureLayer = null

    constructor: (@accessToken, @username, @key) ->
      L.mapbox.accessToken = @accessToken
      @map = L.mapbox.map('map', @username + '.' + @key, attributionControl: false)

    set_view: (latitude, longitude) ->
      @map.setView([latitude, longitude], 12)

    set_marker: (latitude, longitude, symbol, popup) ->
      @featureLayer = L.mapbox.featureLayer(
        type: 'FeatureCollection'
        features: [ {
          type: 'Feature'
          properties:
            'marker-color': gon.marker_color
            'marker-size': 'medium'
            'marker-symbol': symbol
          geometry:
            type: 'Point'
            coordinates: [
              longitude,
              latitude
            ]
        } ]).addTo(@map)

      if popup
        @featureLayer.eachLayer (layer) ->
          $.ajax
            url: $('#map').data 'url-popup'
            success: (data) ->
              layer.bindPopup data, {}
              layer.openPopup()
            error: (jqXHR, textStatus, errorThrown) ->
              console.log "Error :: #{errorThrown}"
          return

    remove_existing_layers: ->
      m = @map
      @map.eachLayer (layer) ->
        if (layer instanceof L.Marker)
          m.removeLayer(layer)

    open_marker: ->
      fl = @featureLayer
      @map.featureLayer.on 'ready', (e) ->
        # Hide popup for small devices
        if !isSmall()
          fl.openPopup()
        return

    disable_touch_zoom: ->
      # Hide touch zoom
      @map.touchZoom.disable()
      @map.scrollWheelZoom.disable()

    disable_dragging: ->
      if isSmall()
        @map.dragging.disable()
        if @map.tap
          @map.tap.disable()

    destroy_map: ->
      @map.off()
      @map.remove()

  @get: (accessToken, username, key, force = false) ->
    if force
      new MapBoxClass(accessToken, username, key)
    else
      instance ?= new MapBoxClass(accessToken, username, key)
