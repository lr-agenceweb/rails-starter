$(document).on 'ready page:load page:restore', ->
  mapbox_init()

###*
# Mapbox init
###
mapbox_init = ->
  if $('#map').length

    L.mapbox.accessToken = gon.mapbox_access_token
    map = L.mapbox.map('map', gon.mapbox_username + '.' + gon.mapbox_key, attributionControl: false).setView([
      gon.latitude
      gon.longitude
    ], 12)

    featureLayer = L.mapbox.featureLayer(
      type: 'FeatureCollection'
      features: [ {
        type: 'Feature'
        properties:
          title: gon.name
          subtitle: gon.subtitle
          address: gon.address
          city: gon.city
          postcode: gon.postcode
          'marker-color': '#F2471A'
          'marker-size': 'medium'
          'marker-symbol': 'camera'
        geometry:
          type: 'Point'
          coordinates: [
            gon.longitude
            gon.latitude
          ]
      } ]).addTo(map)

    featureLayer.eachLayer (layer) ->
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

    # Hide popup for small devices
    map.featureLayer.on 'ready', (e) ->
      if !isSmall()
        featureLayer.openPopup()
      return

    # Hide touch zoom
    map.touchZoom.disable()
    map.scrollWheelZoom.disable()

    if isSmall()
      map.dragging.disable()
      if map.tap
        map.tap.disable()

  return
