# fill in the UI elements with new position data
update_ui = (address, latLng) ->
  $("#gmaps-input-address").autocomplete "close"
  $("#gmaps-input-address").val address
  $("#gmaps-output-latitude").attr("value", latLng.lat())
  $("#gmaps-output-longitude").attr("value", latLng.lng())
  return

# Query the Google geocode object
#
# type: 'address' for search by address
#       'latLng'  for search by latLng (reverse lookup)
#
# value: search query
#
# update: should we update the map (center map and position marker)?
geocode_lookup = (type, value, update) ->

  # default value: update = false
  update = (if typeof update isnt "undefined" then update else false)
  request = {}
  request[type] = value
  geocoder.geocode request, (results, status) ->
    $("#gmaps-error").html ""
    if status is google.maps.GeocoderStatus.OK

      # Google geocoding has succeeded!
      if results[0]

        # Always update the UI elements with new location data
        update_ui results[0].formatted_address, results[0].geometry.location

        # Only update the map (position marker and center map) if requested
        update_map results[0].geometry  if update
      else

        # Geocoder status ok but no results!?
        $("#gmaps-error").html "Sorry, something went wrong. Try again!"
    else

      # Google Geocoding has failed. Two common reasons:
      #   * Address not recognised (e.g. search for 'zxxzcxczxcx')
      #   * Location doesn't map to address (e.g. click in middle of Atlantic)
      if type is "address"

        # User has typed in an address which we can't geocode to a location
        $("#gmaps-error").html "Sorry! We couldn't find " + value + ". Try a different search term, or click the map."
      else

        # User has clicked or dragged marker to somewhere that Google can't do a
        # reverse lookup for. In this case we display a warning.
        $("#gmaps-error").html "Woah... that's pretty remote! You're going to have to manually enter a place name."
        update_ui "", value
    return

  return

# initialise the jqueryUI autocomplete element
autocomplete_init = ->
  geocoder = new google.maps.Geocoder()
  $("#gmaps-input-address").autocomplete

    # source is the list of input options shown in the autocomplete dropdown.
    # see documentation: http://jqueryui.com/demos/autocomplete/
    source: (request, response) ->

      # the geocode method takes an address or LatLng to search for
      # and a callback function which should process the results into
      # a format accepted by jqueryUI autocomplete
      geocoder.geocode
        address: request.term
      , (results, status) ->
        response $.map(results, (item) ->
          label: item.formatted_address # appears in dropdown box
          value: item.formatted_address # inserted into input element when selected
          geocode: item # all geocode data
        )
        return

      return


    # event triggered when drop-down option selected
    select: (event, ui) ->
      update_ui ui.item.value, ui.item.geocode.geometry.location
      # update_map ui.item.geocode.geometry
      return


  # triggered when user presses a key in the address box
  $("#gmaps-input-address").bind "keydown", (event) ->
    if event.keyCode is 13
      geocode_lookup "address", $("#gmaps-input-address").val(), true

      # ensures dropdown disappears when enter is pressed
      $("#gmaps-input-address").autocomplete "disable"
    else

      # re-enable if previously disabled above
      $("#gmaps-input-address").autocomplete "enable"
    return

  return
geocoder = undefined
map = undefined
marker = undefined
# autocomplete_init
$(document).ready ->
  autocomplete_init()
