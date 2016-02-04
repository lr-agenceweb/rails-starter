#
# == MapHelper
#
module MapHelper
  def mapbox_gon_params
    gon.push(
      mapbox_username: Figaro.env.mapbox_username,
      mapbox_key: Figaro.env.mapbox_map_key,
      mapbox_access_token: Figaro.env.mapbox_access_token,
      latitude: @location.try(:latitude),
      longitude: @location.try(:longitude),
      marker_icon: 'building', # @marker_icon.nil? ? '' : @marker_icon,
      marker_color: '#0c708d',
      root_url: I18n.with_locale(@language) { root_path }
    )
  end
end
