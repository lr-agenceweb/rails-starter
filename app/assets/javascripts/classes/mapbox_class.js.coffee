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

    set_marker: (latitude, longitude) ->
      @featureLayer = L.mapbox.featureLayer(
        type: 'FeatureCollection'
        features: [ {
          type: 'Feature'
          properties:
            title: gon.name
            subtitle: gon.subtitle
            address: gon.address
            city: gon.city
            postcode: gon.postcode
            'marker-color': gon.marker_color
            'marker-size': 'medium'
            'marker-symbol': gon.marker_icon
          geometry:
            type: 'Point'
            coordinates: [
              longitude,
              latitude
            ]
        } ]).addTo(@map)

      @featureLayer.eachLayer (layer) ->
        lfp = layer.feature.properties
        content = "
                  <header class='l-header-site popup'>
                    <div class='.l-header-container'>
                      <a href='' class='l-header-site-title-link'>
                        <h3 class='l-header-site-title marker-title text-center'>
                          #{lfp.title}
                          <small class='l-header-site-subtitle'> #{lfp.subtitle} </small>
                        </h3>
                      </a>
                    </div>
                  </header>
                  <div class='row popup'>
                    <div class='small-12 columns'>
                      <p class='text-center'> #{lfp.address} <br /> #{lfp.postcode} - #{lfp.city} </p>
                    </div>
                  </div>"
        layer.bindPopup content, {}

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

  @get: (accessToken, username, key, force = false) ->
    if force
      new MapBoxClass(accessToken, username, key)
    else
      instance ?= new MapBoxClass(accessToken, username, key)
